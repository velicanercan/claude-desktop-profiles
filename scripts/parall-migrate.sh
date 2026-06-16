#!/usr/bin/env bash
###############################################################################
# This script is a convenience helper for Parall users.
#
# It assumes Parall's default directory structure.
#
# If you're using another launcher, use this script as a reference or follow
# the manual migration steps described in the README.
###############################################################################
set -e

BASE="$HOME/Library/Application Support"
echo "Claude Desktop Profile Migration (Parall)"
echo "-----------------------------------------"
echo

if pgrep -f "Claude" >/dev/null; then
  echo "Claude Desktop appears to be running."
  echo "Please close all Claude Desktop instances before running this script."
  exit 1
fi

select SRC in "Original Claude" "Claude Work" "Claude Personal"; do
  case $REPLY in
    1) SRC_PATH="$BASE/Claude"; break;;
    2) SRC_PATH="$BASE/Parall/Claude Work"; break;;
    3) SRC_PATH="$BASE/Parall/Claude Personal"; break;;
  esac
done

select DST in "Claude Work" "Claude Personal"; do
  case $REPLY in
    1) DST_PATH="$BASE/Parall/Claude Work"; break;;
    2) DST_PATH="$BASE/Parall/Claude Personal"; break;;
  esac
done

echo
echo "1) Code history"
echo "2) Cowork history"
echo "3) Both"
read -rp "> " MODE

copy_code() {
  rm -rf "$DST_PATH/claude-code-sessions"
  cp -R "$SRC_PATH/claude-code-sessions" "$DST_PATH/"
}

copy_cowork() {
  mkdir -p "$DST_PATH/local-agent-mode-sessions"
  cp -R "$SRC_PATH/local-agent-mode-sessions/." "$DST_PATH/local-agent-mode-sessions/" 2>/dev/null || true
}

case "$MODE" in
  1) copy_code;;
  2) copy_cowork;;
  3) copy_code; copy_cowork;;
  *) echo "Invalid option"; exit 1;;
esac

echo
echo "✓ Migration completed successfully."
echo
echo "Restart Claude Desktop to see the changes."
