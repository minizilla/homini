{ lib, pkgs }:

let
  activation-bin-path = lib.makeBinPath (with pkgs; [
    nix
    bash
    coreutils
    findutils
  ]);

  cleanup = pkgs.writeShellScript "cleanup" ''
    old_dotfiles=$1
    new_dotfiles=$2
    shift
    shift
    for src_path in "$@"; do
      rel_path="''${src_path#$old_dotfiles/}"
      dst_path="$HOME/$rel_path"
      [[ -e "$new_dotfiles/$rel_path" ]] && continue
      [[ ! -L "$dst_path" ]] && continue
      rm "$dst_path"
    done
  '';

  link = pkgs.writeShellScript "link" ''
    new_dotfiles=$1
    shift
    for src_path in "$@"; do
      rel_path="''${src_path#$new_dotfiles/}"
      dst_path="$HOME/$rel_path"
      [[ -L "$dst_path" ]] && collision_opt='f' || collision_opt='b'
      mkdir -p "$(dirname "$dst_path")"
      ln -s$collision_opt "$src_path" "$dst_path"
    done
  '';
in
pkgs.writeShellScript "activation-script" ''
  export PATH="${activation-bin-path}"

  log_info() { echo "homini: $@"; }
  log_error() { >&2 echo "homini: $@"; }

  xdg_state_home="''${XDG_STATE_HOME:-$HOME/.local/state}"
  gcroots="$xdg_state_home/homini/gcroots/homini"
  if [[ -e $gcroots ]]; then
    old_path="$(readlink -e "$gcroots")"
    old_dotfiles=$(readlink -e "$old_path/homini-dotfiles")
  fi
  new_path="@OUT@"
  new_dotfiles=$(readlink -e "$new_path/homini-dotfiles")

  if [[ "$old_dotfiles" == "$new_dotfiles" ]]; then
    log_info "no dotfiles changes"; exit 0
  fi

  cleanup_old_dotfiles() {
    [[ ! -e "$old_dotfiles" ]] && return
    find $old_dotfiles -type f -exec bash ${cleanup} $old_dotfiles $new_dotfiles {} +
  }

  switch_gcroots() {
    [[ "$old_path" == "$new_path" ]] && return
    nix-store --realise "$new_path" --add-root "$gcroots" > /dev/null
  }

  link_new_dotfiles() {
    local new_dotfiles=$(readlink -e $new_path/homini-dotfiles)
    find $new_dotfiles -type f -exec bash ${link} $new_dotfiles {} +
  }

  cleanup_old_dotfiles
  switch_gcroots
  link_new_dotfiles
''
