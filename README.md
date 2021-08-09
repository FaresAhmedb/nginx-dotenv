# nginx-dotenv
Ever wanted to sync your `.env` with your `nginx.conf`? 😎

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

## License

[BSD 2-Clause](/LICENSE)
