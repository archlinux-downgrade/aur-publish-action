# AUR Publish

Publish an update to an existing AUR package.

## Script Details

The `bin/aur-publish` script automates the following typical process for
releasing a new version of an [AUR][] package:

1. Clone the `aur` repository
1. Update `pkgver` and `pkgrel`
1. Update the checksums and `.SRCINFO` file
1. Commit and push

[aur]: https://aur.archlinux.org

This repository wraps that script in a Docker image and GitHub Action, allowing
fully automating the release of a project through to publishing it to the AUR.

> [!IMPORTANT]
> The script has special-handling for versions with hyphens, which are not
> allowed in Arch Linux. It will replace any hyphens with underscores when
> setting the `pkgver` in the `PKGBUILD`. If you expect this to occur, your
> `PKGBUILD` must take care to restore those hyphens where it matters, such as
> when fetching sources.
>
> See [the wiki](https://wiki.archlinux.org/title/PKGBUILD#pkgver).

## Script Usage

You can place `bin/aur-publish` on `$PATH` and use it directly.

> [!NOTE]
> This will skip any SSH configuration before cloning; you are expected to have
> that pre-configured.

```console
% aur-publish --help
aur-publish --version=VERSION [--release=NUMBER] [--[no-]publish] PACKAGE
Update an existing PKGBUILD's pkgver and publish

Options:
  --version VERSION             Updated pkgver, required
  --release NUMBER              Updated pkgrel, default is 1

  --git-email EMAIL             If given, set this git email before comitting
  --git-username NAME           If given, set this git username before comitting

  --[no-]publish                Actually push to the AUR repository or not,
                                default is to publish

  -h, --help                    Show this usage

  PACKAGE                       Name of AUR package to publish

Environment:
  SSH_PRIVATE_KEY               Private key with AUR access, if run in Docker
```

## Docker Example

```console
% docker build --tag aur-publish .
% docker run -it --rm \
  --env "SSH_PRIVATE_KEY=$(< ~/.ssh/aur)" \
  aur-publish \
  aur-publish downgrade \
    --version "11.5.1-rc-aur.1" \
    --git-email "$(git config get user.email)" \
    --git-username "$(git config get user.name)" \
    --no-publish
```

## GitHub Actions Example

```yaml
# .github/workflows/release.yml
jobs:
  release:
    # ...
    outputs:
      published: # true if a release occurred
      version: # the version that was released

  pkgbuild:
    needs: [release]
    if: ${{ needs.release.outputs.published == 'true' }}

    runs-on: ubuntu-latest

    steps:
      - uses: archlinux-downgrade/aur-publish-action@v1
        with:
          package: downgrade
          version: ${{ needs.release.outputs.version }}
          publish: ${{ github.ref_name == 'main' }}
        env:
          SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
```

See [`downgrade`][downgrade] for a complete example.

[downgrade]: https://github.com/archlinux-downgrade/downgrade

<!-- action-docs-inputs action="action.yml" -->

## Inputs

| name           | description                                                | required | default                                                               |
| -------------- | ---------------------------------------------------------- | -------- | --------------------------------------------------------------------- |
| `package`      | <p>Name of the AUR package to publish</p>                  | `true`   | `""`                                                                  |
| `version`      | <p>Updated <code>pkgver</code> to set in the PKGBUILD</p>  | `true`   | `""`                                                                  |
| `release`      | <p>Updated <code>pkgrel</code> to set in the PKGBUILD</p>  | `false`  | `1`                                                                   |
| `git-email`    | <p><code>git user.email</code> to set before comitting</p> | `false`  | `${{ github.actor_id }}+${{ github.actor }}@users.noreply.github.com` |
| `git-username` | <p><code>git user.name</code> to set before committing</p> | `false`  | `${{ github.actor }}`                                                 |
| `publish`      | <p>Actually publish?</p>                                   | `false`  | `true`                                                                |

<!-- action-docs-inputs action="action.yml" -->

---

The action is licensed AGPLv3. See [COPYING](./COPYING).
