# Setup-New-Linux

This project helps setting up a brand new linux environment with my personal preferred settings.

## How to recover enviornment

To recover the desired environment just git clone the repository add executable permisions to the 
`run.sh` script and run it!

```bash
git clone https://github.com/EnochMtzR/Setup-New-Linux.git ~/.setup
chmod +x ~/.setup/run.sh
cd ~/.setup
./run.sh
```

## Cleanup

If you want to cleanup after installing everything you just have to remove the `.setup` folder inside
your home directory.

```bash
rm -rf ~/.setup
```
