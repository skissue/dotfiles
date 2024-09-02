$env.config.show_banner = false
$env.config.history = {
    file_format: "sqlite"
    isolation: true
}

# https://www.nushell.sh/cookbook/external_completers.html
let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l $in | lines | where {|x| $x != $env.PWD}
}

let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ')
    } else {
        $spans
    }

    match $spans.0 {
        __zoxide_z => $zoxide_completer
        __zoxide_zi => $zoxide_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config.completions.algorithm = "fuzzy"
$env.config.completions.external.completer = $external_completer

# Direnv updates PATH with a "normal" value (colon-separated), we need
# to update it afterwards every time to a proper list for Nushell's
# autocomplete to work
$env.config.hooks.env_change = ($env.config.hooks.env_change |
			        upsert PATH [
				  {|_, after|
				    $env.PATH = ($after | split row (char esep))
				  }
				])
