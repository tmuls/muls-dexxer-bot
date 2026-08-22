#!/usr/bin/env bash
# Muls Dexxer Bot installer.
#
# Copy this file into your Razor Scripts\ folder (the one with Combat\,
# Gear\, etc. under it - not Scripts\Combat\Dexxer\ itself) and run it from
# there. It downloads the latest GitHub release, unzips it, and moves the
# files into Combat\Dexxer\ - everything except *_init.razor files, which
# get a version check first so your tuned config values don't get
# clobbered.

set -euo pipefail
shopt -s nullglob

REPO="tmuls/muls-dexxer-bot"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$SCRIPT_DIR/muls_bot_install_tmp"
ZIP_PATH="$SCRIPT_DIR/muls_bot_install_release.zip"

cleanup() {
    rm -rf "$TMP_DIR"
    rm -f "$ZIP_PATH"
}
trap cleanup EXIT

get_init_version() {
    # $1 = path to a .razor file. Prints the mconfig_InitVersion value, or
    # nothing if the file doesn't have one.
    grep -oE '^[[:space:]]*@setvar!?[[:space:]]+mconfig_InitVersion[[:space:]]+[0-9]+' "$1" 2>/dev/null \
        | grep -oE '[0-9]+$' | head -1
}

find_subdir_ci() {
    # $1 = parent dir, $2 = target subfolder name. Prints the path of an
    # existing subfolder matching $2 case-insensitively (using whatever
    # casing is actually on disk), or "$1/$2" if no such folder exists yet -
    # filesystems on Linux are case-sensitive, so this avoids creating a
    # second, wrongly-cased Combat/Dexxer next to the real one.
    local parent="$1" target="$2" match base
    if [ -d "$parent" ]; then
        for match in "$parent"/*/; do
            base="$(basename "${match%/}")"
            if [ "${base,,}" = "${target,,}" ]; then
                printf '%s' "${match%/}"
                return
            fi
        done
    fi
    printf '%s/%s' "$parent" "$target"
}

echo "Muls Dexxer Bot installer"
echo

COMBAT_DIR="$(find_subdir_ci "$SCRIPT_DIR" "Combat")"
DEST_DIR="$(find_subdir_ci "$COMBAT_DIR" "Dexxer")"

folder_name="$(basename "$SCRIPT_DIR")"
if [ "${folder_name,,}" != "scripts" ]; then
    echo "This doesn't look like a Razor Scripts folder - expected this script"
    echo "to be sitting directly inside a folder named \"Scripts\", but it's in:"
    echo "  $SCRIPT_DIR"
    echo
    read -r -p "Continue anyway and install into $DEST_DIR ? [y/N] " confirm
    case "$confirm" in
        y|Y|yes|YES) ;;
        *)
            echo "Aborting - move this script into your Razor Scripts folder and re-run it."
            exit 1
            ;;
    esac
    echo
fi

echo "Installing into: $DEST_DIR"
echo

mkdir -p "$DEST_DIR"

echo "Fetching latest release info..."
API_JSON="$(curl -sL "https://api.github.com/repos/$REPO/releases/latest")"

DOWNLOAD_URL="$(printf '%s' "$API_JSON" | grep -o '"browser_download_url": *"[^"]*\.zip"' | head -1 | sed -E 's/.*"(https[^"]*)"/\1/')"
TAG_NAME="$(printf '%s' "$API_JSON" | grep -o '"tag_name": *"[^"]*"' | head -1 | sed -E 's/.*"tag_name": *"([^"]*)"/\1/')"

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Could not find a release zip asset - aborting. (Rate limited? No internet? Check https://github.com/$REPO/releases)"
    exit 1
fi

echo "Latest release: ${TAG_NAME:-unknown}"
echo "Downloading..."
curl -sL -o "$ZIP_PATH" "$DOWNLOAD_URL"

echo "Extracting..."
mkdir -p "$TMP_DIR"
unzip -q -o "$ZIP_PATH" -d "$TMP_DIR"

EXTRACTED_DEXXER="$TMP_DIR/Combat/Dexxer"
if [ ! -d "$EXTRACTED_DEXXER" ]; then
    echo "Unexpected zip layout - Combat/Dexxer not found inside the release. Aborting."
    exit 1
fi

echo
echo "Installing files..."
for f in "$EXTRACTED_DEXXER"/*.razor; do
    name="$(basename "$f")"

    case "$name" in
        *_init.razor)
            dest="$DEST_DIR/$name"

            if [ ! -f "$dest" ]; then
                cp "$f" "$dest"
                echo "  [new]      $name"
                continue
            fi

            new_ver="$(get_init_version "$f")"
            old_ver="$(get_init_version "$dest")"
            new_ver="${new_ver:-0}"
            old_ver="${old_ver:-0}"

            if [ "$new_ver" -gt "$old_ver" ]; then
                echo
                echo "  $name: your copy is version $old_ver, the release has version $new_ver."
                echo "  This file holds your own tuned config values."
                echo "    1) Replace with the release's file"
                echo "    2) Keep my file, I'll update it myself later"
                read -r -p "  Choose 1 or 2: " choice
                case "$choice" in
                    1)
                        cp "$f" "$dest"
                        echo "  [replaced] $name"
                        ;;
                    *)
                        echo "  [!] WARNING: keeping your existing $name (version $old_ver)."
                        echo "      New config values from version $new_ver will not be available"
                        echo "      until you update it yourself - the base script may warn about"
                        echo "      this every time it runs until you do."
                        ;;
                esac
            else
                echo "  [ok]       $name is already up to date (version $old_ver)"
            fi
            ;;
        *)
            cp "$f" "$DEST_DIR/$name"
            echo "  [updated]  $name"
            ;;
    esac
done

echo
echo "Checking for other init files in this folder..."
found_other=0
for dest in "$DEST_DIR"/*_init.razor; do
    [ -f "$dest" ] || continue
    name="$(basename "$dest")"
    release_file="$EXTRACTED_DEXXER/$name"

    if [ -f "$release_file" ]; then
        continue  # already handled above
    fi

    found_other=1
    old_ver="$(get_init_version "$dest")"
    echo "  [!] WARNING: $name (version ${old_ver:-unknown}) exists in this folder but wasn't part of this release."
    echo "      It may be for a different/older script and could be out of date - check it by hand."
done
if [ "$found_other" -eq 0 ]; then
    echo "  none found."
fi

echo
echo "Done."
