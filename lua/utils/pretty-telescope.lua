local M = {}

-- Store Utilities we'll use frequently
local telescope_utilities = require("telescope.utils")
local telescope_make_entry_module = require("telescope.make_entry")
local plenary_strings = require("plenary.strings")
local dev_icons = require("nvim-web-devicons")
local telescope_entry_display_module = require("telescope.pickers.entry_display")

-- Obtain Filename icon width
-- --------------------------
-- INSIGHT: This width applies to all icons that represent a file type
local file_type_icon_width = plenary_strings.strdisplaywidth(dev_icons.get_icon("fname", { default = true }))

---- Helper functions ----

-- Gets the File Path and its Tail (the file name) as a Tuple
function M.get_path_and_tail(file_name)
	-- Get the Tail
	local buffer_name_tail = telescope_utilities.path_tail(file_name)

	-- Now remove the tail from the Full Path
	local path_without_tail = require("plenary.strings").truncate(file_name, #file_name - #buffer_name_tail, "")

	-- Apply truncation and other pertaining modifications to the path according to Telescope path rules
	local path_to_display = telescope_utilities.transform_path({
		path_display = { "truncate" },
	}, path_without_tail)

	-- Return as Tuple
	return buffer_name_tail, path_to_display
end

---- Picker functions ----

-- Generates a Find File picker but beautified
-- -------------------------------------------
-- This is a wrapping function used to modify the appearance of pickers that provide a Find File
-- functionality, mainly because the default one doesn't look good. It does this by changing the 'display()'
-- function that Telescope uses to display each entry in the Picker.
--
-- Adapted from: https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1541423345.
--
-- @param (table) pickerAndOptions - A table with the following format:
--                                   {
--                                      picker = '<pickerName>',
--                                      (optional) options = { ... }
--                                   }
function M.pretty_files_picker(picker_and_options)
	-- Parameter integrity check
	if type(picker_and_options) ~= "table" or picker_and_options.picker == nil then
		print(
			"Incorrect argument format. Correct format is: { picker = 'desiredPicker', (optional) options = { ... } }"
		)

		-- Avoid further computation
		return
	end

	-- Ensure 'options' integrity
	options = picker_and_options.options or {}

	-- Use Telescope's existing function to obtain a default 'entry_maker' function
	-- ----------------------------------------------------------------------------
	-- INSIGHT: Because calling this function effectively returns an 'entry_maker' function that is ready to
	--          handle entry creation, we can later call it to obtain the final entry table, which will
	--          ultimately be used by Telescope to display the entry by executing its 'display' key function.
	--          This reduces our work by only having to replace the 'display' function in said table instead
	--          of having to manipulate the rest of the data too.
	local original_entry_maker = telescope_make_entry_module.gen_from_file(options)

	-- INSIGHT: 'entry_maker' is the hardcoded name of the option Telescope reads to obtain the function that
	--          will generate each entry.
	-- INSIGHT: The paramenter 'line' is the actual data to be displayed by the picker, however, its form is
	--          raw (type 'any) and must be transformed into an entry table.
	options.entry_maker = function(line)
		-- Generate the Original Entry table
		local original_entry_table = original_entry_maker(line)

		-- INSIGHT: An "entry display" is an abstract concept that defines the "container" within which data
		--          will be displayed inside the picker, this means that we must define options that define
		--          its dimensions, like, for example, its width.
		local displayer = telescope_entry_display_module.create({
			separator = " ", -- Telescope will use this separator between each entry item
			items = {
				{ width = file_type_icon_width },
				{ width = nil },
				{ remaining = true },
			},
		})

		-- LIFECYCLE: At this point the "displayer" has been created by the create() method, which has in turn
		--            returned a function. This means that we can now call said function by using the
		--            'displayer' variable and pass it actual entry values so that it will, in turn, output
		--            the entry for display.
		--
		-- INSIGHT: We now have to replace the 'display' key in the original entry table to modify the way it
		--          is displayed.
		-- INSIGHT: The 'entry' is the same Original Entry Table but is is passed to the 'display()' function
		--          later on the program execution, most likely when the actual display is made, which could
		--          be deferred to allow lazy loading.
		--
		-- HELP: Read the 'make_entry.lua' file for more info on how all of this works
		original_entry_table.display = function(entry)
			-- Get the Tail and the Path to display
			local tail, path_to_display = M.get_path_and_tail(entry.value)

			-- Add an extra space to the tail so that it looks nicely separated from the path
			local tail_for_display = tail .. " "

			-- Get the Icon with its corresponding Highlight information
			local icon, icon_highlight = telescope_utilities.get_devicons(tail)

			-- INSIGHT: This return value should be a tuple of 2, where the first value is the actual value
			--          and the second one is the highlight information, this will be done by the displayer
			--          internally and return in the correct format.
			return displayer({
				{ icon,            icon_highlight },
				tail_for_display,
				{ path_to_display, "TelescopeResultsComment" },
			})
		end

		return original_entry_table
	end

	-- Finally, check which file picker was requested and open it with its associated options
	if picker_and_options.picker == "find_files" then
		require("telescope.builtin").find_files(options)
	elseif picker_and_options.picker == "git_files" then
		require("telescope.builtin").git_files(options)
	elseif picker_and_options.picker == "oldfiles" then
		require("telescope.builtin").oldfiles(options)
	elseif picker_and_options.picker == "" then
		print("Picker was not specified")
	else
		print("Picker is not supported by Pretty Find Files")
	end
end

-- Generates a Grep Search picker but beautified
-- ----------------------------------------------
-- This is a wrapping function used to modify the appearance of pickers that provide Grep Search
-- functionality, mainly because the default one doesn't look good. It does this by changing the 'display()'
-- function that Telescope uses to display each entry in the Picker.
--
-- @param (table) pickerAndOptions - A table with the following format:
--                                   {
--                                      picker = '<pickerName>',
--                                      (optional) options = { ... }
--                                   }
function M.pretty_grep_picker(picker_and_options)
	-- Parameter integrity check
	if type(picker_and_options) ~= "table" or picker_and_options.picker == nil then
		print(
			"Incorrect argument format. Correct format is: { picker = 'desiredPicker', (optional) options = { ... } }"
		)

		-- Avoid further computation
		return
	end

	-- Ensure 'options' integrity
	options = picker_and_options.options or {}

	-- Use Telescope's existing function to obtain a default 'entry_maker' function
	-- ----------------------------------------------------------------------------
	-- INSIGHT: Because calling this function effectively returns an 'entry_maker' function that is ready to
	--          handle entry creation, we can later call it to obtain the final entry table, which will
	--          ultimately be used by Telescope to display the entry by executing its 'display' key function.
	--          This reduces our work by only having to replace the 'display' function in said table instead
	--          of having to manipulate the rest of the data too.
	local original_entry_maker = telescope_make_entry_module.gen_from_vimgrep(options)

	-- INSIGHT: 'entry_maker' is the hardcoded name of the option Telescope reads to obtain the function that
	--          will generate each entry.
	-- INSIGHT: The paramenter 'line' is the actual data to be displayed by the picker, however, its form is
	--          raw (type 'any) and must be transformed into an entry table.
	options.entry_maker = function(line)
		-- Generate the Original Entry table
		local original_entry_table = original_entry_maker(line)

		-- INSIGHT: An "entry display" is an abstract concept that defines the "container" within which data
		--          will be displayed inside the picker, this means that we must define options that define
		--          its dimensions, like, for example, its width.
		local displayer = telescope_entry_display_module.create({
			separator = " ", -- Telescope will use this separator between each entry item
			items = {
				{ width = file_type_icon_width },
				{ width = nil },
				{ width = nil }, -- Maximum path size, keep it short
				{ remaining = true },
			},
		})

		-- LIFECYCLE: At this point the "displayer" has been created by the create() method, which has in turn
		--            returned a function. This means that we can now call said function by using the
		--            'displayer' variable and pass it actual entry values so that it will, in turn, output
		--            the entry for display.
		--
		-- INSIGHT: We now have to replace the 'display' key in the original entry table to modify the way it
		--          is displayed.
		-- INSIGHT: The 'entry' is the same Original Entry Table but is is passed to the 'display()' function
		--          later on the program execution, most likely when the actual display is made, which could
		--          be deferred to allow lazy loading.
		--
		-- HELP: Read the 'make_entry.lua' file for more info on how all of this works
		original_entry_table.display = function(entry)
			---- Get File columns data ----
			-------------------------------

			-- Get the Tail and the Path to display
			local tail, path_to_display = M.get_path_and_tail(entry.filename)

			-- Get the Icon with its corresponding Highlight information
			local icon, icon_highlight = telescope_utilities.get_devicons(tail)

			---- Format Text for display ----
			---------------------------------

			-- Add coordinates if required by 'options'
			local coordinates = ""

			if not options.disable_coordinates then
				if entry.lnum then
					if entry.col then
						coordinates = string.format(" -> %s:%s", entry.lnum, entry.col)
					else
						coordinates = string.format(" -> %s", entry.lnum)
					end
				end
			end

			-- Append coordinates to tail
			tail = tail .. coordinates

			-- Add an extra space to the tail so that it looks nicely separated from the path
			local tail_for_display = tail .. " "

			-- Encode text if necessary
			local text = options.file_encoding and vim.iconv(entry.text, options.file_encoding, "utf8") or entry.text

			-- INSIGHT: This return value should be a tuple of 2, where the first value is the actual value
			--          and the second one is the highlight information, this will be done by the displayer
			--          internally and return in the correct format.
			return displayer({
				{ icon,            icon_highlight },
				tail_for_display,
				{ path_to_display, "TelescopeResultsComment" },
				text,
			})
		end

		return original_entry_table
	end

	-- Finally, check which file picker was requested and open it with its associated options
	if picker_and_options.picker == "live_grep" then
		require("telescope.builtin").live_grep(options)
	elseif picker_and_options.picker == "grep_string" then
		require("telescope.builtin").grep_string(options)
	elseif picker_and_options.picker == "" then
		print("Picker was not specified")
	else
		print("Picker is not supported by Pretty Grep Picker")
	end
end

return M
