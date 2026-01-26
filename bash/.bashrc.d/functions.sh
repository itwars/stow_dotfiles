function neoclean(){
   rm -rf ~/.local/share/nvim
   rm -rf ~/.local/state/nvim
   rm -rf ~/.cache/nvim
}
function go() {
    if [ $1 = 'build' ]; then
        command go build -ldflags="-s -w" ${@:2}
    else
        command go $@
    fi
}
function goinit() {
    mkdir -p $1
    cd $1
    go mod init $1
}
function goinit-wasm() {
    mkdir -p $1
    cd $1
    go mod init $1
    cp "$(go env GOROOT)/misc/wasm/wasm_exec.js" .
    mkdir server
cat << EOF > index.html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <script src="wasm_exec.js"></script>
    <script>
        // polyfill
        if (!WebAssembly.instantiateStreaming) {
            WebAssembly.instantiateStreaming = async(resp, importObject) => {
                const source = await (await resp).arrayBuffer();
                return await WebAssembly.instantiate(source, importObject);
            };
        }
        const go = new Go();
        WebAssembly.instantiateStreaming(fetch("main.wasm"), go.importObject)
            .then((result) => {
                go.run(result.instance);
            })
    </script>
</head>
<body>
</body>
</html>
EOF
cat << EOF > build.sh
# Compile with the following line
GOARCH=wasm GOOS=js go build -o main.wasm
EOF
chmod +x build.sh
cat << EOF > server/server.go
package main

import (
        "flag"
        "log"
        "net/http"
)

func main() {
    port := flag.String("p", "80", "port to serve on")
    dir := flag.String("d", ".", "the directory of static file to host")
    flag.Parse()

    http.Handle("/", http.FileServer(http.Dir(*dir)))
    log.Printf("Serving UI %s on HTTP port: %s\n", *dir, *port)
    log.Fatal(http.ListenAndServe(":"+*port, nil))
}
EOF
}

function settitle() {
    printf "\033k$1\033\\"
}

function boxtitle()
{
    title=$1
    body="│ ${*:2} │"
    m=${#body}
    # let size=(m/2)-${#title}+${#title}+(m/2)+1-${#title}
    let sizeb=(m/2)
    let sizea=(m%2)
    edge=$(seq  -f "─" -s '' $m | sed 's/./─/g')
    echo $edge | sed s/─/┌/1 | sed s/─$/┐/
    printf "│%*s%*s│\n" $sizeb "$title" $sizea
    echo $edge | sed s/─/├/1 | sed s/─$/┤/
    echo $body
    echo $edge | sed s/─/└/1 | sed s/─$/┘/
}

function border()
{
    title="│ $* │"
    edgeTop=$(echo "$title" | sed 's/./─/g')
    edgeBot=$(echo "$title" | sed 's/./─/g')
    echo $edgeTop | sed s/─/┌/1 | sed s/─$/┐/
    echo $title
    echo $edgeBot | sed s/─/└/1 | sed s/─$/┘/
}

function brew_today() {
   new=`brew list -1tl 2> /dev/null | grep "$(LC_TIME="us_US.UTF-8"  date +"%b %-d")" | awk '{print $NF}'`
   boxtitle "brew package updated today" $new
}

function brew_update () {
    new=`brew outdated | awk '{print $1}'`
    brew upgrade --greedy
    brew cleanup --prune=1
    border $new
#    ansible cluster -m apt -a "upgrade=yes update_cache=yes autoremove=yes" --become
}
function brew_clean_dep(){
    brew bundle dump
    brew bundle --force cleanup
    rm Brewfile
}
function tmux_colour(){
    for i in {0..255}; do
        printf "\x1b[38;5;${i}mcolour${i}\x1b[0m "
    done
}
function git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/( ───契\1) /'`
    echo "${BRANCH}"
}
function pdfcompressN ()
{
   for f in "$@"; do
      nom="${f%.*}-c"
      echo $nom.pdf
      gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$nom.pdf" "$f"
   done
}
function pdfcompress ()
{
   #gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dEmbedAllFonts=true -dSubsetFonts=true -dColorImageDownsampleType=/Bicubic -dColorImageResolution=144 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=144 -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=144 -sOutputFile=$1.compressed.pdf $1; 
   #gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -sOutputFile=output.pdf architecture20211029.pdf
   gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$1.compressed.pdf $1
}
function ping_range() {
   for i in {1..254} ;do (ping 192.168.255.$i -c 2 -t 10  >/dev/null && printf "192.168.255.%03d\n" $i &) ;done | sort
}
function ansi_color() {
    for i in {0..255}; do
      printf "$(tput setab $i)| $i |"
    done
}

function remove_old_snap () 
{
# Removes old revisions of snaps
LANG=fr_FR.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
  while read snapname revision; do
		echo $snapname $revision;
        sudo snap remove "$snapname" --revision="$revision";
  done
}

ssh() {
    if [ -f "$HOME/.sshtools/.bashrc_remote" ] && [ -f "$HOME/.sshtools/.vimrc_remote" ] && [ -f "$HOME/.sshtools/.webshare.py" ]; then
        # Compress and encode files
        REMOTE_BASHRC=$(gzip -c "$HOME/.sshtools/.bashrc_remote" | base64)
        REMOTE_VIMRC=$(gzip -c "$HOME/.sshtools/.vimrc_remote" | base64)
        REMOTE_WEBSHARE=$(gzip -c "$HOME/.sshtools/.webshare.py" | base64)
        /usr/bin/ssh -t $1 "
            echo '$REMOTE_BASHRC' | base64 -d | gunzip > /tmp/.bashrc_remote && \
            echo '$REMOTE_VIMRC' | base64 -d | gunzip > /tmp/.vimrc_remote && \
            echo '$REMOTE_WEBSHARE' | base64 -d | gunzip > /tmp/webshare.py && \
            bash --rcfile /tmp/.bashrc_remote
        "
    else
        /usr/bin/ssh "$@"
    fi
}

alias sshc='/usr/bin/ssh'

function xdccelite()
{
  xdccJS --host irc.rizon.net --port 6697 --tls --wait 2 --nickname slave --path ~/Downloads/weechat/ --channel ELITEWAREZ ELITE-CHAT --bot "$1" --download $2
}

function xdccmoviegods()
{
  xdccJS --host irc.eu.abjects.net --port 6697 --tls --wait 2 --nickname slave --path ~/Downloads/weechat/ --channel moviegods mg-chat --bot "$1" --download $2
}

function xdccbeast()
{
  xdccJS --host irc.eu.abjects.net --port 6697 --tls --wait 2 --nickname slave --path ~/Downloads/weechat/ --channel beast-xdcc beast-chat --bot "$1" --download $2
}

function upgrade()
{
  sudo dnf upgrade 
  sudo snap refresh 
  flatpak update 
}

function apk()
{
  distro=`lsb_release -i | cut -d':' -f2 | cut -c2- | tr '[:upper:]' '[:lower:]'` 
  if [ $1 = 'upgrade' ]; then
    if [ $distro = 'alpine' ]; then
      sudo apk upgrade ${@:2}
    fi
    if [ $distro = 'debian' ]; then
      sudo apt upgrade
    fi
    if [ $distro = 'cachyos' ]; then
      sudo pacman -Syu
    fi
  fi
  if [ $1 = 'add' ]; then
    if [ $distro = 'alpine' ]; then
      sudo apk add ${@:2}
    fi
    if [ $distro = 'debian' ]; then
      sudo apt install ${@:2}
    fi
    if [ $distro = 'cachyos' ]; then
      sudo pacman -S ${@:2}
    fi
  fi
  if [ $1 = 'search' ]; then
    if [ $distro = 'alpine' ]; then
      apk search ${@:2}
    fi
    if [ $distro = 'debian' ]; then
      apt search ${@:2}
    fi
    if [ $distro = 'cachyos' ]; then
      pacman -Ss ${@:2}
    fi
  fi
  if [ $1 = 'del' ]; then
    if [ $distro = 'alpine' ]; then
      sudo apk del ${@:2}
    fi
    if [ $distro = 'debian' ]; then
      sudo apt autoremove ${@:2}
    fi
    if [ $distro = 'cachyos' ]; then
      sudo pacman -R ${@:2}
    fi
  fi
}
