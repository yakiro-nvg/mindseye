#!/usr/bin/env bash
curl --form token=${COVERITY_SCAN_TOKEN} \
  --form email=yakiro.nvg@gmail.com \
  --form file=@mindseye.tgz \
  https://scan.coverity.com/builds?project=yakiro-nvg%2Fmindseye
