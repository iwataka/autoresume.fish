# This script imitates Zsh's auto_resume feature as described below.
#
# https://zsh.sourceforge.io/Doc/Release/Options.html#index-AUTORESUME
# > AUTO_RESUME (-W)
# >     Treat single word simple commands without redirection as candidates for
# >     resumption of an existing job.

function _auto_resume_preexec --on-event fish_preexec
    set -l _auto_resume_command (string trim "$argv[1]")
    # If the given command is not a single word, skip auto_resume.
    if string match -rq '\s' "$_auto_resume_command"
        return 0
    end
    ## If the given command is not an executable file, skip auto_resume.
    if test (type -t "$_auto_resume_command") != "file"
        return 0
    end
    # Get the job ID of the background job whose command equals to the given one.
    set -g _auto_resume_jobid (jobs |
            # Remove the first header line.
            tail -n -1 |
            # Extract jobs whose command (without args) equals to the given one
            awk '$5 == "'$_auto_resume_command'"' |
            # Extract only the first match.
            head -n 1 |
            # Extract Group ID.
            awk '{ print $2 }' |
            string trim)
    if test -n "$_auto_resume_jobid"
        # Create the function which brings the job to foreground and
        # override the given command with this function.
        function "$_auto_resume_command"
            fg "$_auto_resume_jobid"
        end
    end
end

# Clean up functions and variables created by _auto_resume_preexec.
function _auto_resume_postexec --on-event fish_postexec
    # Check if auto_resume is performed
    if test -n "$_auto_resume_jobid"
        # Delete the function overriding the original command.
        set -l _auto_resume_command (string trim "$argv[1]")
        functions -e "$_auto_resume_command"
        # Delete the job ID created by _auto_resume_preexec.
        set -e _auto_resume_jobid
    end
end
