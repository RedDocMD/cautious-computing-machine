#!/usr/bin/env python3
import subprocess
import re
import pathlib
import sys
import urllib.request as req
from datetime import datetime

# Python script to update all the dotfiles
home_dir = pathlib.Path.home()
backup_file = home_dir/pathlib.PurePath(".backuplist")

with open(backup_file) as f:
    lines = [s[0:(len(s) - 1)] for s in f.readlines()]
    comment_reg = re.compile(r'^\s*\#.*$')
    empty_reg = re.compile(r'^\s*$')
    imp_lines = []
    for line in lines:
        if comment_reg.match(line) is None and empty_reg.match(line) is None:
            imp_lines.append(line)
    paths = []
    for line in imp_lines:
        paths.append(home_dir/pathlib.PurePath(line))

    git_comm = ["/usr/bin/git", f"--git-dir={home_dir/pathlib.PurePath('cfg')/pathlib.PurePath('.git')}", f"--work-tree={home_dir}"]

    # Stage files
    print('Staging files ...')
    for path in paths:
        print(f'Staging {path}')
        add_comm = git_comm + ["add", str(path)]
        add_proc = subprocess.run(add_comm, capture_output=True, text=True)
        if add_proc.returncode != 0:
            print(add_proc.stderr, end='')
            sys.exit(1)
    
    # Commit file
    curr_date = datetime.now()
    commit_comm = git_comm + ["commit", "-m", f'"{curr_date.strftime("%a, %B %d, %Y - %I:%M:%S %p")}"']
    print("\nCommiting files ...")
    commit_proc = subprocess.run(commit_comm, capture_output=True, text=True)
    if commit_proc.returncode != 0:
        print(commit_proc.stderr, end='')
        sys.exit(1)
    else:
        print(commit_proc.stdout, end='')

    # Check for net connection
    print("\nChecking for internet connection ...")
    try:
        req.urlopen('https://www.google.com')
        print("... Ok")
    except Exception:
        print("Cannot connect to the internet!")
        sys.exit(1)

    # Push to Github
    print("Pushing to Github ...")
    push_comm = git_comm + ["push", "origin", "main"]
    push_proc = subprocess.run(push_comm, capture_output=True, text=True)
    if push_proc.returncode != 0:
        print(push_proc.stderr, end='')
        sys.exit(1)
    else:
        print(push_proc.stdout, end='')
