local M = {}

-- Used constants in this file
M.__SUNO = "suno"
M.__CP = "cp"

-- A table for supported filetypes
M.__supported_filetypes = {
  "cpp",
}

---Checks if suno supports the given filetype
---@param ext string
M.__is_a_supported_filetype = function(ext)
  for _, filetype in ipairs(M.__supported_filetypes) do
    if filetype == ext then
      return true
    end
  end
  return false
end

---Returns true if the file at given path exist, else false
---@param filepath string
M.__does_file_exist = function(filepath)
  local file = io.open(filepath, "r")
  if file then
    file:close()
    return true
  end
  return false
end

---Creates the file if it does not exist
---@param filepath string
M.__create_file_if_it_does_not_exist = function(filepath)
  if not M.__does_file_exist(filepath) then
    local file = io.open(filepath, "w")
    if file then
      file:close()
    else
      print("[suno] I not able to create " .. filepath)
    end
  end
end

---Returns the file size if file is found, else returns zero
---@param filepath string
---@return integer
M.__get_file_size = function(filepath)
  local file = io.open(filepath, "r")
  if file then
    local size = file:seek "end"
    file:close()
    return size
  end
  return 0
end

-- Perform operations if cpp filetype is identified
M.__handle_cpp = function()
  local debounce_time = 500 -- In milliseconds
  local last_save_time = 0
  local temp_dir = "suno_temp"
  local temp_exec = temp_dir .. "/temp_exec"
  local input_file = "input.txt"
  local output_file = "output.txt"
  local max_output_size = 1024 * 1024 * 5 -- Max output file size in bytes (e.g., 5 MB)

  local build_and_run_cpp = function()
    -- Full path to the current file
    local current_file = vim.fn.expand "%:p"

    -- Debounce logic
    local current_time = vim.fn.reltimefloat(vim.fn.reltime())

    if current_time - last_save_time < debounce_time / 1000 then
      -- Do not do the save and run task
      return
    end

    last_save_time = current_time -- update the last save time in memory
    print "[suno] Compiling and running your c++ file ... :)"

    -- Check if the g++ executable exists
    if vim.fn.executable "g++" == 0 then
      print "[suno] g++ executable was not found! ensure its installation :|"
      return
    end

    -- if the temp directory does not exist, create one
    if vim.fn.isdirectory(temp_dir) == 0 then
      vim.fn.mkdir(temp_dir, "p")
    end

    -- Create input.txt and output.txt if they do not already exist
    M.__create_file_if_it_does_not_exist(input_file)
    M.__create_file_if_it_does_not_exist(output_file)

    -- NOTE: Turn this on for strict mode compilation
    local strict_mode = false
    local build_command = ""

    if strict_mode then
      build_command = string.format(
        "g++ -std=c++23 -ggdb -O2 -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion -Werror -pedantic-errors -g %s -o %s",
        current_file,
        temp_exec
      )
    else
      build_command = string.format(
        "g++ -std=c++23 -O2 -Wall %s -o %s",
        current_file,
        temp_exec
      )
    end

    -- Execute the build and run command
    vim.fn.system(build_command)

    local run_command = string.format("./%s < %s > %s 2>&1", temp_exec, input_file, output_file)

    -- Start running the program and monitor the output size
    local job_id = nil

    job_id = vim.fn.jobstart(run_command, {
      on_stdout = function(_, data, _)
        if data then
          local size = M.__get_file_size(output_file)
          if size > max_output_size and job_id then
            vim.fn.jobstop(job_id)
            print "[suno] Memory overflow!, looks like your program is in an infite loop printing stuff :|"
          end
        end
      end,
      on_stderr = function(_, data, _)
        if data then
          -- TODO: Do something in case of std_error
          return
        end
      end,
      on_exit = function(_, exit_code, _)
        if exit_code == 124 then
          print "[suno] Execution timeout! Check if your code has any infinite loop :|"
        elseif exit_code == 137 then
          print "[suno] I have killed the watch process due to excessive output."
        end
      end,
    })

    -- Print the final message
    print "[suno] Done. OK :)"
  end

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = M.__SUNO,
    pattern = "*.cpp",
    callback = build_and_run_cpp,
  })
end

-- Internal main function
M.__main = function()
  -- Get the filetype on which the :suno command was spawned
  local current_filetype = vim.bo.filetype
  -- Check if it is supported currently
  local is_current_filetype_supported = M.__is_a_supported_filetype(current_filetype)

  -- Now to perform some nil guards
  if current_filetype == "" then
    return
  end

  if not is_current_filetype_supported then
    return
  end

  if current_filetype ~= "cpp" then
    return
  end

  print "[suno] I am ready :)"

  M.__handle_cpp()
end

---Setup function as per the requirement of lazy.nvim
M.setup = function()
  -- Make a neovim function to launch suno's main
  vim.api.nvim_create_user_command(M.__SUNO, M.__main, {
    desc = "[suno] suno your current filetype!",
  })

  -- Create an autocommand group for suno
  vim.api.nvim_create_augroup(M.__SUNO, {
    clear = true,
  })

  -- Create an autocommand for CP
  vim.api.nvim_create_user_command(M.__CP, function()
    -- Get the directory where this init.lua file is located
    local source = debug.getinfo(1, "S").source:sub(2)
    local plugin_dir = vim.fn.fnamemodify(source, ':h')
    local template_path = plugin_dir .. '/cpp_template.cpp'

    -- Read the template file
    local template_lines = vim.fn.readfile(template_path)

    -- Replace current buffer content with template
    vim.api.nvim_buf_set_lines(0, 0, -1, false, template_lines)

    -- Move cursor to a specific position (e.g., line 10, column 0)
    vim.api.nvim_win_set_cursor(0, { 40, 3 })
  end, {
    desc = 'Populate current file with C++ template'
  })
end

return M
