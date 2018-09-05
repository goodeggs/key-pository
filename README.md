# Good Eggs Key-Pository

## Getting Started

To add yourself to this repository, you'll need to:

- [ ] Check out a branch
- [ ] Add your SSH public key to the `/keys` directory
- [ ] Add yourself to `folks.yml`
- [ ] Pull request your changes and add your onboarding buddy as a reviewer

### Add your SSH public key

If you don't already have an SSH key in your `~/.ssh` directory, follow these directions to generate one:

https://help.github.com/articles/generating-ssh-keys

The comment (at the end of your keyfile) must match your `@goodeggs.com` email address.

Next, copy your public key into the `keys` directory:

```sh
$ cp ~/.ssh/id_rsa.pub keys/{username}.pub
```

> Note: Make sure to add your public, _not your private_, SSH key!

### Adding yourself to `folks.yml`

Add an entry to the bottom of `folks.yml` that looks like this (replace the values with your own):

```
-
  name: Nathan Houle
  username: nathan
  github: ndhoule
  npm: ndhoule
```

`username` should be the beginning fragment of your `@goodeggs.com` email address.

## Development

### Getting Started

```sh
$ npm install
```
