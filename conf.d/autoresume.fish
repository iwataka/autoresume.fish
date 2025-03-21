# This imitates Zsh's auto_resume feature.
# If the given command name matches the background job, bring it to foreground
# instead of executing it newly.
function _auto_resume_preexec --on-event fish_preexec
    # Check if the given commmand includes any white space (that is followed by args).
    # If so, skip auto-resume.
    if string match -rq '\s' "$argv"
        return 0
    end
    # Get the job ID of the background job whose command equals to the given one.
    set -g _auto_resume_jobid (jobs |
            # delete the first header line
            tail -n -1 |
            # extract jobs whose command (without args) equals to the given one
            awk '$5 == "'$argv'"' |
            # extract only the first match
            head -n 1 |
            # extract Group ID
            awk '{ print $2 }' |
            string trim)
    if test -n "$_auto_resume_jobid"
        # If the given command is function, save it as an alias.
        if functions -q "$argv"
            functions -c "$argv" _auto_resume_"$argv"
        end
        # Create the function which brings the job to foreground and
        # override the given command by the function.
        function "$argv"
            fg "$_auto_resume_jobid"
        end
    end
end

# Delete some functions and variables created by _auto_resume_preexec.
function _auto_resume_postexec --on-event fish_postexec
    # Check if auto-resume is done.
    if test -n "$_auto_resume_jobid"
        # Delete the function overriding the original command.
        functions -e "$argv"
        # Restore the original function if it exists.
        if functions -q _auto_resume_"$argv"
            functions -c _auto_resume_"$argv" "$argv"
            functions -e _auto_resume_"$argv"
        end
        # Delete the jobid created by _auto_resume_preexec.
        set -e _auto_resume_jobid
    end
end
