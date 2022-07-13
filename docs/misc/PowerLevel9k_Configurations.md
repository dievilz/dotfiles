# POWERLEVEL9K CONFIGURATIONS

### Prompt Segments
#### System Status Segments
##### Hardware Status
  01. `battery`                - Current battery status.
  02. `disk_usage`             - Disk usage of your current partition.
  03. `load`                   - Your machine's load averages.
  04. `ram`                    - Show free RAM.
##### OS Segments
  06. `date`                   - System date.
  07. `time`                   - System time.
  08. `os_icon`                - Display a nice little icon, depending on your operating system.
  05. `swap`                   - Prints the current swap size.
##### Terminal Segments
  09. `background_jobs`        - Indicator for background jobs.
  10. `command_execution_time` - Display the time the current command took to execute.
  11. `history`                - The command number for the current line.
  12. `status`                 - The return code of the previous command.
  13. `vi_mode`                - Your prompt's Vi editing mode (NORMAL|INSERT).
##### Network Segments
  14. `ip`                     - Shows the current IP address.
  15. `public_ip`              - Shows your public IP address.
  16. `vpn_ip`                 - Shows the current VPN IP address.
##### Directory Segments
  17. `dir`                    - Your current working directory.
  18. `dir_writable`           - Displays a lock icon, if you do not have write permissions on the current folder.
##### Session Hierarchy Segments
  19. `root_indicator`         - An indicator if the user has superuser status.
  20. `ssh`                    - Indicates whether or not you are in an SSH session.
##### Session Context Segments
  21. `context`                - Your username and host, conditionalized based on $USER and SSH status.
  22. `user`                   - Your current username
  23. `host`                   - Your current host name.

#### Development Environment Segments
  24. `vcs`             - Information about this Git or Hg repository (if you are in one).

##### Language Segments
###### GoLang Segments
  25. `go_version`   - Show the current Go version.
###### JavaScript / NodeJS Segments
  26. `node_version` - Show the version number of the installed NodeJS.
  27. `nodeenv`      - nodeenv prompt for displaying NodeJS version and environment name.
  28. `nvm`          - Show the version of NodeJS that is currently active, if it differs from the version used by NVM
###### PHP Segments
  29. `php_version`      - Show the current PHP version.
  30. `laravel_version`  - Show the current Laravel version.
  31. `symfony2_tests`   - Show a ratio of test classes vs code classes for Symfony2.
  32. `symfony2_version` - Show the current Symfony2 version, if you are in a Symfony2-Project dir.
###### Python Segments
  33. `virtualenv` - Your Python VirtualEnv.
  34. `anaconda`   - Your active Anaconda environment.
  35. `pyenv`      - Your active Python version as reported by the first word of pyenv version. Note that the segment is not displayed if that word is system i.e. the segment is inactive if you are using system Python.
###### Ruby Segments
  36. `chruby`      - Ruby environment information using Chruby (if one is active).
  37. `rbenv`       - Ruby environment information using Rbenv (if one is active).
  38. `rspec_stats` - Show a ratio of test classes vs code classes for RSpec.
  39. `rvm`         - Ruby environment information using $GEM_HOME and $MY_RUBY_HOME (if one is active).
###### Rust Segments
  40. `rust_version`  - Display the current Rust version and logo.
###### Swift Segments
  41. `swift_version` - Show the version number of the installed Swift.
###### Java Segments
  42. `java_version`  - Show the current Java version.

##### Cloud Segments
###### AWS Segments
  43. `aws`            - The current AWS profile, if active.
  44. `aws_eb_env`     - The current Elastic Beanstalk Environment.
  45. `docker_machine` - The current Docker Machine.
  46. `kubecontext`    - The current context of your kubectl configuration.
  47. `dropbox`        - Indicates Dropbox directory and syncing status using dropbox-cli

#### Other
  48. `custom_command` - Create a custom segment to display the output of an arbitrary command.
  49. `todo`           - Shows the number of tasks in your todo.txt tasks file.
  50. `detect_virt`    - Virtualization detection with systemd
  51. `newline`        - Continues the prompt on a new line.
  52. `openfoam`       - Shows the currently sourced OpenFOAM environment.



### Prompt Segments Custom Colors
#### System Status Segments
01. `battery`                -
02. `disk_usage`             - darkgray
03. `load`                   -
04. `ram`                    -
06. `date`                   -
07. `time`                   - cyan <-----------------------------------------
08. `os_icon`                - white <----------------------------------------
05. `swap`                   -
09. `background_jobs`        - 114 - mavam - palegreen3a
10. `command_execution_time` - magenta <--------------------------------------
11. `history`                - gray <-----------------------------------------
12. `status`                 - OK: 046 - green1; Error: 196 - red1
13. `vi_mode`                -
14. `ip`                     - 027 - dodgerblue2
15. `public_ip`              -
16. `vpn_ip`                 -
17. `dir`                    - blue <-----------------------------------------
18. `dir_writable`           - red <------------------------------------------
19. `root_indicator`         - 232 - negro chido
20. `ssh`                    - 221 - amarillo palido
21. `context`                - lightmagenta <---------------------------------
22. `user`                   -
23. `host`                   -

#### Development Environment Segments
24. `vcs`                    - 070 - chartreuse3 (Clean)
                               yellow            (Modified) <-------------
                               130 - darkorange3 (Untracked)



COLORES

code | name             | apodo

000  | black            | semifondo
008  | grey             | fondo
235  | grey15           | clear

013  | fuchsia          | morado

027  | dodgerblue2      | azul medio oscuro

028  | green4           | verde feo 1 vcs -
029  | springgreen4     | verde feo 2 vcs -
035  | springgreen3     | verde feo 3 vcs -

070  | chartreuse3      | verde vcs chido
040  | green3           | verde chido
048  | springgreen1     | verde azulado
114  |                  | verde backgrounds 1
120  |                  | verde backgrounds 2

130  | darkorange3      | naranja feo vcs

160  | red3             | rojo chido
196  | red1             | rojo brillante

178  | gold3            | amarillo anaranjado -
221  | lightgoldenrod2  | amarillo palido -
226  | yellow1          | amarillo chido

232  | grey3            | negro chido
236  | grey19           | gris darker
243  | grey46           | light gris oscuro

