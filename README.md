<div id="top"></div>

> **Fork Notice:** This fork replaces the PHP backend with a static site hosted on **S3 + CloudFront**.
> The ScoreSaber API proxy is handled by CloudFront Functions (path rewriting + CORS).
> Infrastructure is managed with Terraform and deployed via GitHub Actions.
>
> **Local development:**
> ```bash
> npm install
> npm run dev
> ```
> Then open `http://localhost:5173` in your browser or add it as a Browser Source in OBS.

# BeatSaber-Overlay
<hr />

<div align="center">
   <a href="https://overlay.hyldrazolxy.fr">
      <img src="https://overlay.hyldrazolxy.fr/preview/Overlay_BS_New_Light.gif" alt="liveDemo" />
   </a>
   <p>
      <a href="https://github.com/HyldraZolxy/BeatSaber-Overlay/issues">Report Bug</a>
      -
      <a href="https://github.com/HyldraZolxy/BeatSaber-Overlay/issues">Request Feature</a>
      -
      <a href="https://ko-fi.com/hyldrazolxy">Support me on Ko-fi! <3</a>
   </p>
</div>

<details>
   <summary>Table of Contents</summary>
   <ol>
      <li>
         <a href="#What-is-this?">What is this?</a>
      </li>
      <li>
         <a href="#getting-started">Getting Started</a>
         <ul>
            <li>
               <a href="#prerequisites">Prerequisites</a>
            </li>
            <li>
               <a href="#installation">Installation</a>
            </li>
         </ul>
      </li>
      <li>
         <a href="#options">Options</a>
      </li>
      <li>
         <a href="#deployment">Deployment</a>
      </li>
      <li>
         <a href="#contact">Contact</a>
      </li>
      <li>
         <a href="#credit">Credit</a>
      </li>
   </ol>
</details>
<br />

<div>
   <strong>Work with:</strong>

- **[BeatSaberPlus](https://github.com/hardcpp/BeatSaberPlus)**: BS ver (1.21.0 & 1.22.0 & 1.22.1 & 1.23.0 & 1.24.0)
- **[HTTPStatus](https://github.com/opl-/beatsaber-http-status/)**: BS ver (1.17.0 & 1.18.0 & 1.19.0 & 1.20.0)
- **[HTTPSiraStatus](https://github.com/opl-/beatsaber-http-status/)**: BS ver (1.21.0 & 1.22.0 & 1.22.1 & 1.23.0 & 1.24.0)
- **[DataPuller](https://github.com/opl-/beatsaber-http-status/)**: BS ver (1.20.0 & more ?)
</div>

<div>
   <strong>3 skins:</strong>

- **Default**: Default style
- **Freemium**: Premium design
- **Reselim**: Reselim skin
</div>
<hr />

## What is this?
This is an overlay that can be used with a plugin (mod) for BeatSaber.<br />
It takes the data produced by the plugin(s) in order to display them, so you can display them on a record or a stream

## Getting Started
To use the Overlay, it is necessary to follow the instructions below to ensure that it will work properly

### Prerequisites

1. You will need to download **one** of the four plugins that will be used to connect the overlay to your game
- [BeatSaberPlus Plugin](https://github.com/hardcpp/BeatSaberPlus#discord--downloadupdate)
- [HTTPStatus Plugin](https://github.com/opl-/beatsaber-http-status/releases)
- [HTTPSiraStatus Plugin](https://github.com/denpadokei/HttpSiraStatus/releases)
- [DataPuller Plugin](https://github.com/kOFReadie/BSDataPuller/releases)

**Don't forget to install the dependencies of the plugin !**
<br />
<br />

2. You will need a Stream software
- [OBS](https://obsproject.com/)
- [StreamLabs](https://streamlabs.com/)
- [Other software (All recommended by Twitch)](https://help.twitch.tv/s/article/recommended-software-for-broadcasting?language=en_US)

### Installation

1. Install your stream software, I'm not going to show you how, you're a big boy ;3

2. Put the previously downloaded plugin in your Beat Saber folder `Beat Saber\Plugins\ `
    ```
    Beat Saber\Plugins\BeatSaberPlus.dll
    Or
    Beat Saber\Plugins\BeatSaberHTTPStatus.dll
    Or
    Saber\Plugins\HttpSiraStatus.dll
    Or
    Beat Saber\Plugins\DataPuller.dll
    ```

3. Open your web browser and write
   ```
    https://overlay.hyldrazolxy.fr/
    ```
4. Click on settings icon to display the setup panel

5. After setting up your overlay, copy the URL with a click on the link button

<img src="https://overlay.hyldrazolxy.fr/preview/settings.png" alt="Setting button" />
<img src="https://overlay.hyldrazolxy.fr/preview/copyLink.png" alt="Link button" />

<p align="right">(<a href="#top">back to top</a>)</p>

## Options

### `General Settings`
`IP`<br />
If you want to use a second pc to stream, you can write it's ip address to make the overlay connect to your game. If not, leave it blank

### `Player Card Settings`
**(Obviously, if you don't add the Score Saber link in, it won't work)**<br />

`ScoreSaber link`<br />
If you want to use the player card, you have to give your ScoreSaber ID or the link of your ScoreSaber profile

`Position`<br />
This is to change the position of the player card

`Scale`<br />
This is to change the scale of the player card<br />

### `Song Card Settings`
`Skin`<br />
This is to change the skin of the song card<br />

`Position`<br />
This is to change the position of the song card<br />

`Scale`<br />
This is to change the scale of the song card<br />

<p align="right">(<a href="#top">back to top</a>)</p>

## Deployment

This fork deploys to AWS using Terraform (S3 + CloudFront) and GitHub Actions (CI/CD).

### Prerequisites

- An AWS account with a Route53 hosted zone
- An IAM role with OIDC trust for your GitHub repo (for GitHub Actions to assume)
- The IAM role needs permissions for: S3, CloudFront, ACM, Route53, and the Terraform state bucket

### GitHub Actions Configuration

**Secrets** (sensitive):

| Secret | Description |
|--------|-------------|
| `AWS_ROLE_ARN` | ARN of the IAM role for GitHub Actions to assume via OIDC |

**Variables** (non-sensitive):

| Variable | Description | Example |
|----------|-------------|---------|
| `AWS_REGION` | AWS region for the S3 bucket and CloudFront | `us-west-2` |
| `SITE_DOMAIN` | Domain name used for `sed` replacement in deployed files | `hyldrazolxy-overlay.bakas.io` |
| `TF_STATE_BUCKET` | S3 bucket for Terraform state | `my-tfstate-bucket` |
| `TF_STATE_KEY` | Key path for the state file | `hyldrazolxy-overlay/terraform.tfstate` |
| `TF_STATE_REGION` | Region of the Terraform state bucket | `us-west-2` |
| `TF_VAR_DOMAIN_NAME` | Domain name for the overlay site | `hyldrazolxy-overlay.bakas.io` |
| `TF_VAR_ROUTE53_ZONE_NAME` | Route53 hosted zone name | `bakas.io` |
| `TF_VAR_S3_BUCKET_NAME` | S3 bucket name for site content | `my-overlay-bucket` |
| `CLOUDFRONT_DISTRIBUTION_ID` | CloudFront distribution ID (set after first `terraform apply`) | `E1234567890` |

### Environments

Create a `production` environment with required reviewers. The Terraform apply step waits for approval before applying changes.

### First Deploy

1. Push to `main` — the Terraform workflow creates infrastructure (requires `production` approval)
2. Set `CLOUDFRONT_DISTRIBUTION_ID` from the Terraform output
3. Re-run the Deploy workflow to sync files to S3

<p align="right">(<a href="#top">back to top</a>)</p>

## Contact
You can contact me on Discord `Hyldra Zolxy#1910` to ask for various changes, improvements or even special requests! I'm always open to new ideas and suggestions ;)

## Credit
Thanks to:
- @hardcpp for the Cache system!
- @reselim for giving me the permission to copy the skin of his Beat Saber Overlay <3

##### Thanks all and cya <3
If you like the overlay, you can support me on <a href="https://ko-fi.com/hyldrazolxy"><strong>Ko-fi</strong></a>! I really appreciate it :3<br />
<p align="right">(<a href="#top">back to top</a>)</p>