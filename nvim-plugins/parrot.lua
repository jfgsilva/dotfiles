return {
	"frankroeder/parrot.nvim",
	dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
	opts = {
		-- The provider definitions include endpoints, API keys, default parameters,
		-- and topic model arguments for chat summarization, with an example provided for Anthropic.
		providers = {
			anthropic = {
				-- api_key = os.getenv("ANTHROPIC_API_KEY"),
				-- OPTIONAL: Alternative methods to retrieve API key
				-- Using GPG for decryption:
				-- api_key = { "gpg", "--decrypt", vim.fn.expand("$HOME") .. "/anthropic_api_key.txt.gpg" },
				-- Using macOS Keychain:
				api_key = {
					"op",
					"read",
					'op://Private/"API Credential Anthropic"/credential',
					"--account my.1password.com",
				},
				-- api_key = { "/usr/bin/security", "find-generic-password", "-s anthropic-api-key", "-w" },
				endpoint = "https://api.anthropic.com/v1/messages",
				topic_prompt = "You only respond with 3 to 4 words to summarize the past conversation.",
				-- usually a cheap and fast model to generate the chat topic based on
				-- the whole chat history
				topic = {
					model = "claude-3-haiku-20240307",
					params = { max_tokens = 32 },
				},
				-- default parameters for the actual model
				params = {
					chat = { max_tokens = 4096 },
					command = { max_tokens = 4096 },
				},
			},
			ollama = {},
			-- insert ollama here
		},

		-- default system prompts used for the chat sessions and the command routines
		system_prompt = {
			chat = "you are a devops expert. be terse, and concise on your explanations",
			command = "you are a devops expert",
		},

		-- the prefix used for all commands
		cmd_prefix = "Prt",

		-- optional parameters for curl
		curl_params = {},

		-- The directory to store persisted state information like the
		-- current provider and the selected models
		state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/persisted",

		-- The directory to store the chats (searched with PrtChatFinder)
		chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/chats",

		-- Chat user prompt prefix
		chat_user_prefix = "🗨:",

		-- llm prompt prefix
		llm_prefix = "🦜:",

		-- Explicitly confirm deletion of a chat file
		chat_confirm_delete = true,

		-- When available, call API for model selection
		online_model_selection = false,

		-- Local chat buffer shortcuts
		chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
		chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
		chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
		chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },

		-- Option to move the cursor to the end of the file after finished respond
		chat_free_cursor = false,

		-- use prompt buftype for chats (:h prompt-buffer)
		chat_prompt_buf_type = false,

		-- Default target for  PrtChatToggle, PrtChatNew, PrtContext and the chats opened from the ChatFinder
		-- values: popup / split / vsplit / tabnew
		toggle_target = "vsplit",

		-- The interactive user input appearing when can be "native" for
		-- vim.ui.input or "buffer" to query the input within a native nvim buffer
		-- (see video demonstrations below)
		user_input_ui = "native",

		-- Popup window layout
		-- border: "single", "double", "rounded", "solid", "shadow", "none"
		style_popup_border = "single",

		-- margins are number of characters or lines
		style_popup_margin_bottom = 8,
		style_popup_margin_left = 1,
		style_popup_margin_right = 2,
		style_popup_margin_top = 2,
		style_popup_max_width = 160,

		-- Prompt used for interactive LLM calls like PrtRewrite where {{llm}} is
		-- a placeholder for the llm name
		command_prompt_prefix_template = "🤖 {{llm}} ~ ",

		-- auto select command response (easier chaining of commands)
		-- if false it also frees up the buffer cursor for further editing elsewhere
		command_auto_select_response = true,

		-- fzf_lua options for PrtModel and PrtChatFinder when plugin is installed
		fzf_lua_opts = {
			["--ansi"] = true,
			["--sort"] = "",
			["--info"] = "inline",
			["--layout"] = "reverse",
			["--preview-window"] = "nohidden:right:75%",
		},

		-- Enables the query spinner animation
		enable_spinner = true,
		-- Type of spinner animation to display while loading
		-- Available options: "dots", "line", "star", "bouncing_bar", "bouncing_ball"
		spinner_type = "star",
		hooks = {
			Complete = function(prt, params)
				local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted."
        ]]
				local model_obj = prt.get_model("command")
				prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
			end,
			CompleteFullContext = function(prt, params)
				local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{filecontent}}
        ```

        Please look at the following section specifically:
        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted.
        ]]
				local model_obj = prt.get_model("command")
				prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
			end,
			CompleteMultiContext = function(prt, params)
				local template = [[
        I have the following code from {{filename}} and other realted files:

        ```{{filetype}}
        {{multifilecontent}}
        ```

        Please look at the following section specifically:
        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted.
        ]]
				local model_obj = prt.get_model("command")
				prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
			end,
			Explain = function(prt, params)
				local template = [[
        Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
        Break down the code's functionality, purpose, and key components.
        The goal is to help the reader understand what the code does and how it works.

        ```{{filetype}}
        {{selection}}
        ```

        Use the markdown format with codeblocks and inline code.
        Explanation of the code above:
        ]]
				local model = prt.get_model("command")
				prt.logger.info("Explaining selection with model: " .. model.name)
				prt.Prompt(params, prt.ui.Target.new, model, nil, template)
			end,
			FixBugs = function(prt, params)
				local template = [[
        You are an expert in {{filetype}}.
        Fix bugs in the below code from {{filename}} carefully and logically:
        Your task is to analyze the provided {{filetype}} code snippet, identify
        any bugs or errors present, and provide a corrected version of the code
        that resolves these issues. Explain the problems you found in the
        original code and how your fixes address them. The corrected code should
        be functional, efficient, and adhere to best practices in
        {{filetype}} programming.

        ```{{filetype}}
        {{selection}}
        ```

        Fixed code:
        ]]
				local model_obj = prt.get_model("command")
				prt.logger.info("Fixing bugs in selection with model: " .. model_obj.name)
				prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
			end,
			Optimize = function(prt, params)
				local template = [[
        You are an expert in {{filetype}}.
        Your task is to analyze the provided {{filetype}} code snippet and
        suggest improvements to optimize its performance. Identify areas
        where the code can be made more efficient, faster, or less
        resource-intensive. Provide specific suggestions for optimization,
        along with explanations of how these changes can enhance the code's
        performance. The optimized code should maintain the same functionality
        as the original code while demonstrating improved efficiency.

        ```{{filetype}}
        {{selection}}
        ```

        Optimized code:
        ]]
				local model_obj = prt.get_model("command")
				prt.logger.info("Optimizing selection with model: " .. model_obj.name)
				prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
			end,
			UnitTests = function(prt, params)
				local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Please respond by writing table driven unit tests for the code above.
        ]]
				local model_obj = prt.get_model("command")
				prt.logger.info("Creating unit tests for selection with model: " .. model_obj.name)
				prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
			end,
			Debug = function(prt, params)
				local template = [[
        I want you to act as {{filetype}} expert.
        Review the following code, carefully examine it, and report potential
        bugs and edge cases alongside solutions to resolve them.
        Keep your explanation short and to the point:

        ```{{filetype}}
        {{selection}}
        ```
        ]]
				local model_obj = prt.get_model("command")
				prt.logger.info("Debugging selection with model: " .. model_obj.name)
				prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
			end,
			CommitMsg = function(prt, params)
				local futils = require("parrot.file_utils")
				if futils.find_git_root() == "" then
					prt.logger.warning("Not in a git repository")
					return
				else
					local template = [[
          I want you to act as a commit message generator. I will provide you
          with information about the task and the prefix for the task code, and
          I would like you to generate an appropriate commit message using the
          conventional commit format. Do not write any explanations or other
          words, just reply with the commit message.
          Start with a short headline as summary but then list the individual
          changes in more detail.

          Here are the changes that should be considered by this message:
          ]] .. vim.fn.system("git diff --no-color --no-ext-diff --staged")
					local model_obj = prt.get_model("command")
					prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
				end
			end,
			SpellCheck = function(prt, params)
				local chat_prompt = [[
        Your task is to take the text provided and rewrite it into a clear,
        grammatically correct version while preserving the original meaning
        as closely as possible. Correct any spelling mistakes, punctuation
        errors, verb tense issues, word choice problems, and other
        grammatical mistakes.
        ]]
				prt.ChatNew(params, chat_prompt)
			end,
			CodeConsultant = function(prt, params)
				local chat_prompt = [[
          Your task is to analyze the provided {{filetype}} code and suggest
          improvements to optimize its performance. Identify areas where the
          code can be made more efficient, faster, or less resource-intensive.
          Provide specific suggestions for optimization, along with explanations
          of how these changes can enhance the code's performance. The optimized
          code should maintain the same functionality as the original code while
          demonstrating improved efficiency.

          Here is the code
          ```{{filetype}}
          {{filecontent}}
          ```
        ]]
				prt.ChatNew(params, chat_prompt)
			end,
			ProofReader = function(prt, params)
				local chat_prompt = [[
        I want you to act as a proofreader. I will provide you with texts and
        I would like you to review them for any spelling, grammar, or
        punctuation errors. Once you have finished reviewing the text,
        provide me with any necessary corrections or suggestions to improve the
        text. Highlight the corrected fragments (if any) using markdown backticks.

        When you have done that subsequently provide me with a slightly better
        version of the text, but keep close to the original text.

        Finally provide me with an ideal version of the text.

        Whenever I provide you with text, you reply in this format directly:

        ## Corrected text:

        {corrected text, or say "NO_CORRECTIONS_NEEDED" instead if there are no corrections made}

        ## Slightly better text

        {slightly better text}

        ## Ideal text

        {ideal text}
        ]]
				prt.ChatNew(params, chat_prompt)
			end,
		},
	},
	keys = {
		{ "<leader>p", mode = { "n" }, desc = "[P]arrot" },
		{ "<leader>pc", "<cmd>PrtChatNew<cr>", mode = { "n" }, desc = "New Chat" },
		{ "<leader>pt", "<cmd>PrtChatToggle<cr>", mode = { "n" }, desc = "Toggle Popup Chat" },
		{ "<leader>pf", "<cmd>PrtChatFinder<cr>", mode = { "n" }, desc = "Chat Finder" },
		{ "<leader>pr", "<cmd>PrtRewrite<cr>", mode = { "n" }, desc = "Inline Rewrite" },
		{ "<leader>pj", "<cmd>PrtRetry<cr>", mode = { "n" }, desc = "Retry Rewrite/Append/Prepend" },
		{ "<leader>pa", "<cmd>PrtAppend<cr>", mode = { "n" }, desc = "Append" },
		{ "<leader>po", "<cmd>PrtPrepend<cr>", mode = { "n" }, desc = "Prepend" },
		{ "<leader>ps", "<cmd>PrtStop<cr>", mode = { "n" }, desc = "Stop Execution" },
		{ "<leader>pi", "<cmd>PrtComplete<cr>", mode = { "n" }, desc = "Complete Selection" },
		{ "<leader>px", "<cmd>PrtContext<cr>", mode = { "n" }, desc = "Open Context File" },
		{ "<leader>pn", "<cmd>PrtModel<cr>", mode = { "n" }, desc = "Select Model" },
		{ "<leader>pp", "<cmd>PrtProvider<cr>", mode = { "n" }, desc = "Select Provider" },
		{ "<leader>pq", "<cmd>PrtAsk<cr>", mode = { "n" }, desc = "Ask a Question" },
	},
}
