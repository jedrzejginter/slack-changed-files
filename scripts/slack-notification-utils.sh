#!/bin/bash -e

function get_section_json {
  section_header=$1
  files=${@:2}
  
  markdown=""

  for file in ${files[@]}
  do
    # If the file is `pages/standards/example.md`
    # we want to strip the `pages` part and extension 
    # so the pathname is `standards/example`
    pathname=$(echo "$file" | sed "s/pages\///" | sed "s/\.mdx*//")

    list_item_markdown="\n• <https://paytrix-io.github.io/web-coding-guidelines/$pathname|$file>"
    markdown+=${list_item_markdown}
  done
 
  section_json="{}"

  if [[ "${markdown}" != "" ]]
  then
    section_json="{
      \"type\": \"section\",
      \"text\": {
        \"type\": \"mrkdwn\",
        \"text\": \"*${section_header}*${markdown}\"
      }
    }"
  fi

  echo "${section_json}"
}

function get_slack_message_json {
  output_json=()

  for section_json in "$@"
  do
    if [[ "${section_json}" != "{}" ]]
    then
      output_json+=",${section_json}"
    fi
  done

  echo "${output_json}"
}

