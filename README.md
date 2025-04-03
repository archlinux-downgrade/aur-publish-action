# AUR Publish

Publish an update to an existing AUR package

<!-- action-docs-usage action="action.yml" -->

## Usage

```yaml
- uses: @
  with:
    package:
    # Name of the AUR package to publish
    #
    # Required: true
    # Default: ""

    version:
    # Updated `pkgver` to set in the PKGBUILD
    #
    # Required: true
    # Default: ""

    release:
    # Updated `pkgrel` to set in the PKGBUILD
    #
    # Required: false
    # Default: 1

    git-email:
    # `git user.email` to set before comitting
    #
    # Required: false
    # Default: ${{ github.actor_id }}+${{ github.actor }}@users.noreply.github.com

    git-username:
    # `git user.name` to set before committing
    #
    # Required: false
    # Default: ${{ github.actor }}

    publish:
    # Actually publish?
    #
    # Required: false
    # Default: true
```

<!-- action-docs-usage action="action.yml" -->

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
