<div id="top"></div>

# BeatSaber-Overlay

Fork of [HyldraZolxy/BeatSaber-Overlay](https://github.com/HyldraZolxy/BeatSaber-Overlay) — a streaming overlay for Beat Saber.

This fork replaces the PHP backend with a static site hosted on **S3 + CloudFront**. The ScoreSaber API proxy is handled by CloudFront Functions (path rewriting + CORS). Infrastructure is managed with Terraform and deployed via GitHub Actions.

## Local Development

```bash
npm install
npm run dev
```

Then open `http://localhost:5173` in your browser or add it as a Browser Source in OBS.

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

---

## Original README

*The following is from the [upstream repository](https://github.com/HyldraZolxy/BeatSaber-Overlay).*

> [![liveDemo](https://overlay.hyldrazolxy.fr/preview/Overlay_BS_New_Light.gif)](https://overlay.hyldrazolxy.fr)
>
> [Report Bug](https://github.com/HyldraZolxy/BeatSaber-Overlay/issues) - [Request Feature](https://github.com/HyldraZolxy/BeatSaber-Overlay/issues) - [Support me on Ko-fi! <3](https://ko-fi.com/hyldrazolxy)
>
> **Work with:**
> - **[BeatSaberPlus](https://github.com/hardcpp/BeatSaberPlus)**: BS ver (1.21.0 & 1.22.0 & 1.22.1 & 1.23.0 & 1.24.0)
> - **[HTTPStatus](https://github.com/opl-/beatsaber-http-status/)**: BS ver (1.17.0 & 1.18.0 & 1.19.0 & 1.20.0)
> - **[HTTPSiraStatus](https://github.com/opl-/beatsaber-http-status/)**: BS ver (1.21.0 & 1.22.0 & 1.22.1 & 1.23.0 & 1.24.0)
> - **[DataPuller](https://github.com/opl-/beatsaber-http-status/)**: BS ver (1.20.0 & more ?)
>
> **3 skins:** Default, Freemium, Reselim
>
> ---
>
> ### What is this?
> This is an overlay that can be used with a plugin (mod) for BeatSaber.
> It takes the data produced by the plugin(s) in order to display them, so you can display them on a record or a stream
>
> ### Getting Started
> To use the Overlay, it is necessary to follow the instructions below to ensure that it will work properly
>
> #### Prerequisites
>
> 1. You will need to download **one** of the four plugins that will be used to connect the overlay to your game
>    - [BeatSaberPlus Plugin](https://github.com/hardcpp/BeatSaberPlus#discord--downloadupdate)
>    - [HTTPStatus Plugin](https://github.com/opl-/beatsaber-http-status/releases)
>    - [HTTPSiraStatus Plugin](https://github.com/denpadokei/HttpSiraStatus/releases)
>    - [DataPuller Plugin](https://github.com/kOFReadie/BSDataPuller/releases)
>
>    **Don't forget to install the dependencies of the plugin !**
>
> 2. You will need a Stream software
>    - [OBS](https://obsproject.com/)
>    - [StreamLabs](https://streamlabs.com/)
>    - [Other software (All recommended by Twitch)](https://help.twitch.tv/s/article/recommended-software-for-broadcasting?language=en_US)
>
> #### Installation
>
> 1. Install your stream software
> 2. Put the previously downloaded plugin in your Beat Saber folder (`Beat Saber\Plugins\`)
> 3. Open your web browser and go to `https://overlay.hyldrazolxy.fr/`
> 4. Click on settings icon to display the setup panel
> 5. After setting up your overlay, copy the URL with a click on the link button
>
> ### Options
>
> **General Settings** - `IP`: If you want to use a second pc to stream, you can write its ip address to make the overlay connect to your game. If not, leave it blank
>
> **Player Card Settings** *(requires ScoreSaber link)* - `ScoreSaber link`: Your ScoreSaber ID or profile link | `Position`: Change position | `Scale`: Change scale
>
> **Song Card Settings** - `Skin`: Change skin | `Position`: Change position | `Scale`: Change scale
>
> ### Contact
> You can contact me on Discord `Hyldra Zolxy#1910` to ask for various changes, improvements or even special requests! I'm always open to new ideas and suggestions ;)
>
> ### Credit
> Thanks to:
> - @hardcpp for the Cache system!
> - @reselim for giving me the permission to copy the skin of his Beat Saber Overlay <3
>
> Thanks all and cya <3
> If you like the overlay, you can support me on [**Ko-fi**](https://ko-fi.com/hyldrazolxy)! I really appreciate it :3
