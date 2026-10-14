#!/usr/bin/env bash
# CI preparation draft: requires an official matching CLI ZIP and SHA256.
set -euo pipefail
python3 - <<'PY'
import os,re,urllib.parse
u=urllib.parse.urlparse(os.environ['CLI_URL'])
host=u.hostname or ''
if u.scheme!='https' or not any(host==d or host.endswith('.'+d) for d in ['huawei.com','huaweicloud.com']):
    raise SystemExit('Use an HTTPS URL from the official Huawei download service.')
if not re.fullmatch(r'[A-Fa-f0-9]{64}',os.environ['CLI_SHA256']):
    raise SystemExit('A valid official SHA256 is required.')
PY
bundle_dir="$RUNNER_TEMP/harmony-cli"
mkdir -p "$bundle_dir"
curl --fail --location --retry 3 --connect-timeout 30 --max-time 900 "$CLI_URL" -o "$bundle_dir/cli.zip"
printf '%s  %s\n' "$CLI_SHA256" "$bundle_dir/cli.zip" | sha256sum --check --status
unzip -q "$bundle_dir/cli.zip" -d "$bundle_dir/unpacked"
node_bin=$(find "$bundle_dir/unpacked" -type f -path '*/bin/node' -print -quit)
ohpm_bin=$(find "$bundle_dir/unpacked" -type f -path '*/bin/ohpm' -print -quit)
hvigor_bin=$(find "$bundle_dir/unpacked" -type f -path '*/bin/hvigorw' -print -quit)
java_bin=$(find "$bundle_dir/unpacked" -type f -path '*/bin/java' -print -quit)
sdk_dir=$(find "$bundle_dir/unpacked" -type d -path '*/sdk' -print -quit)
if [[ -z "$node_bin" || -z "$ohpm_bin" || -z "$hvigor_bin" || -z "$java_bin" || -z "$sdk_dir" ]]; then
  echo 'The archive layout differs or lacks bundled tools. Review the matching official CLI instructions before continuing.'
  exit 1
fi
chmod +x "$node_bin" "$ohpm_bin" "$hvigor_bin" "$java_bin"
for executable in "$node_bin" "$ohpm_bin" "$hvigor_bin" "$java_bin"; do
  dirname "$executable" >> "$GITHUB_PATH"
done
printf 'JAVA_HOME=%s\n' "$(dirname "$(dirname "$java_bin")")" >> "$GITHUB_ENV"
printf 'DEVECO_SDK_HOME=%s\n' "$sdk_dir" >> "$GITHUB_ENV"
