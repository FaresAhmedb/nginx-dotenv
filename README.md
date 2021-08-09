# nginx-dotenv
Ever wanted to sync your `.env` with `nginx.conf`? 😎

## Installation & Usage

Just git clone the repo!

```bash
$ git clone https://github.com/FaresAhmedb/nginx-dotenv
$ cd nginx-dotenv
$ chmod +x nginx-dotenv.sh
$ export DOTENV=/etc/nginx/.env  # Defaults to .env in the cwd.
$ ./nginx-dotenv.sh -c /etc/nginx/nginx.conf
```

Soon on bpkg, and basher!

## Contributing
Feel free to open an issue/pull request to suggest or contribute to the project.

## FAQ
**Q**: DOTENV environment variables is not working!

**A**: You are probably usign the script with sudo (another user) to still use sudo and pass the DOTENV variable use `sudo -E` instead of `sudo`. The '-E' argument or '--preserve-env' passes your environment variables to sudo. https://linux.die.net/man/8/sudo.

## License

[BSD 2-Clause](/LICENSE)
