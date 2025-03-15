# favorite-dirs

Enter your favorite directories using keyboard shortcuts!  
favorite-dirs is an [oh-my-zsh plugin](https://github.com/robbyrussell/oh-my-zsh) plugin.

## Installation

1. Clone this repository into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`)

    ```sh
    git clone https://github.com/kozahk/zsh-favorite-dirs ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/favorite-dirs
    ```
2. Add the plugin to the list of plugins for Oh My Zsh to load (inside `~/.zshrc`):

    ```sh
    plugins=( 
        # other plugins...
        favorite-dirs
    )
    ```

## Usage

- Assign current directory to a slot:

    ```sh
    fav <slot number>
    ```

- Go to a directory assigned to a slot:

    ```
    Alt + <slot number>
    ```

- List all slots:

    ```sh
    favlist
    ```

- Remove directory from a slot:

    ```sh
    favrem <slot number>
    ```

## Todo
- [ ] Unify the shortcuts among keyboard layouts.
    - [x] English
    - [x] Czech