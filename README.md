### Install hammerspoon
```
brew install --cask hammerspoon
```

### Clone this into some directory

```
mkdir -p ~/dev/mac/hammerspoon
git clone https://github.com/abdusco/hammerspoon ~/dev/mac/hammerspoon
```

Tell hammerspoon to load that file

```
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/dev/mac/hammerspoon/init.lua"
```