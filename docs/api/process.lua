---@meta

---
---Functionality that allows you to launch subprocesses and read
---or write to them in a non-blocking fashion.
---@class process
process = {}

---Error triggered when the stdout, stderr or stdin fails while reading
---or writing, its value is platform dependent, so the value declared on this
---interface does not represents the real one.
---@type integer
process.ERROR_PIPE = -1

---Error triggered when a read or write action is blocking,
---its value is platform dependent, so the value declared on this
---interface does not represents the real one.
---@type integer
process.ERROR_WOULDBLOCK = -2

---Error triggered when a process takes more time than that specified
---by the deadline parameter given on process:start(),
---its value is platform dependent, so the value declared on this
---interface does not represents the real one.
---@type integer
process.ERROR_TIMEDOUT = -3

---Error triggered when trying to terminate or kill a non running process,
---its value is platform dependent, so the value declared on this
---interface does not represents the real one.
---@type integer
process.ERROR_INVAL = -4

---Error triggered when no memory is available to allocate the process,
---its value is platform dependent, so the value declared on this
---interface does not represents the real one.
---@type integer
process.ERROR_NOMEM = -5

---Used for the process:close_stream() method to close stdin.
---@type integer
process.STREAM_STDIN = 0

---Used for the process:close_stream() method to close stdout.
---@type integer
process.STREAM_STDOUT = 1

---Used for the process:close_stream() method to close stderr.
---@type integer
process.STREAM_STDERR = 2

---Instruct process:wait() to wait until the process ends.
---@type integer
process.WAIT_INFINITE = -1

---Instruct process:wait() to wait until the deadline given on process:start()
---@type integer
process.WAIT_DEADLINE = -2

---Used for the process.options stdin, stdout and stderr fields.
---@type integer
process.REDIRECT_DEFAULT = 0

---Used for the process.options stdin, stdout and stderr fields.
---@type integer
process.REDIRECT_PIPE = 1

---Used for the process.options stdin, stdout and stderr fields.
---@type integer
process.REDIRECT_PARENT = 2

---Used for the process.options stdin, stdout and stderr fields.
---@type integer
process.REDIRECT_DISCARD = 3

---Used for the process.options stdin, stdout and stderr fields.
---@type integer
process.REDIRECT_STDOUT = 4

---@alias process.errortype
---|>'process.ERROR_PIPE'
---| 'process.ERROR_WOULDBLOCK'
---| 'process.ERROR_TIMEDOUT'
---| 'process.ERROR_INVAL'
---| 'process.ERROR_NOMEM'

---@alias process.streamtype
---|>'process.STREAM_STDIN'
---| 'process.STREAM_STDOUT'
---| 'process.STREAM_STDERR'

---@alias process.waittype
---|>'process.WAIT_INFINITE'
---| 'process.WAIT_DEADLINE'

---@alias process.redirecttype
---|>'process.REDIRECT_DEFAULT'
---| 'process.REDIRECT_PIPE'
---| 'process.REDIRECT_PARENT'
---| 'process.REDIRECT_DISCARD'
---| 'process.REDIRECT_STDOUT'

---
--- Options that can be passed to process.start()
---@class process.options
---@field public timeout number
---@field public cwd string
---@field public stdin process.redirecttype
---@field public stdout process.redirecttype
---@field public stderr process.redirecttype
---@field public env table<string, string>
process.options = {}

---
---Create and start a new process
---
---@param command_and_params table First index is the command to execute
---and subsequente elements are parameters for the command.
---@param options process.options
---
---@return process | nil
---@return string errmsg
---@return process.errortype | integer errcode
function process:start(command_and_params, options) end

---
---Translates an error code into a useful text message
---
---@param code integer
---
---@return string | nil
function process.strerror(code) end

---
---Get the process id.
---
---@return integer id Process id or 0 if not running.
function process:pid() end

---
---Read from the given stream type, if the process fails with a ERROR_PIPE it is
---automatically destroyed returning nil along error message and code.
---
---@param stream process.streamtype
---@param len? integer Amount of bytes to read, defaults to 2048.
---
---@return string | nil
---@return string errmsg
---@return process.errortype | integer errcode
function process:read(stream, len) end

---
---Read from stdout, if the process fails with a ERROR_PIPE it is
---automatically destroyed returning nil along error message and code.
---
---@param len? integer Amount of bytes to read, defaults to 2048.
---
---@return string | nil
---@return string errmsg
---@return process.errortype | integer errcode
function process:read_stdout(len) end

---
---Read from stderr, if the process fails with a ERROR_PIPE it is
---automatically destroyed returning nil along error message and code.
---
---@param len? integer Amount of bytes to read, defaults to 2048.
---
---@return string | nil
---@return string errmsg
---@return process.errortype | integer errcode
function process:read_stderr(len) end

---
---Write to the stdin, if the process fails with a ERROR_PIPE it is
---automatically destroyed returning nil along error message and code.
---
---@param data string
---
---@return integer | nil bytes The amount of bytes written or nil if error
---@return string errmsg
---@return process.errortype | integer errcode
function process:write(data) end

---
---Allows you to close a stream pipe that you will not be using.
---
---@param stream process.streamtype
---
---@return integer | nil
---@return string errmsg
---@return process.errortype | integer errcode
function process:close_stream(stream) end

---
---Wait the specified amount of time for the process to exit.
---
---@param timeout integer | process.waittype Time to wait in milliseconds,
---if 0, the function will only check if process is running without waiting.
---
---@return integer | nil exit_status The process exit status or nil on error
---@return string errmsg
---@return process.errortype | integer errcode
function process:wait(timeout) end

---
---Sends SIGTERM to the process
---
---@return boolean | nil
---@return string errmsg
---@return process.errortype | integer errcode
function process:terminate() end

---
---Sends SIGKILL to the process
---
---@return boolean | nil
---@return string errmsg
---@return process.errortype | integer errcode
function process:kill() end

---
---Get the exit code of the process or nil if still running.
---
---@return number | nil
function process:returncode() end

---
---Check if the process is running
---
---@return boolean
function process:running() end
