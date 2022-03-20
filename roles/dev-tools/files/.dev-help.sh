gcof() { git checkout -b $USER-${1}; jira; }
gcob() { git checkout $USER-${1}; jira; }
gcim() {
  commit_message="$(getissue) $1"
  echo "Message: $commit_message"
  git commit -m "$commit_message"
}
gopr() {
  [[ $(git remote get-url origin) =~ git@([a-zA-Z0-9]+\.[a-zA-Z]{2,5}):(.*).git$ ]]
  xdg-open "https://${BASH_REMATCH[1]}/${BASH_REMATCH[2]}/pull/new/$(git symbolic-ref --short HEAD)" &> /dev/null
}
alias ga="git add"
alias ga.="git add ."
alias gs="git status"
alias gd="git diff"
alias gpoh="git push origin HEAD"
alias gb="git branch"
alias gco="git checkout"
alias gcom="git checkout dev"
alias gl="git pull"
alias gci="git commit -m"
gh(){
  echo -e "\033[1m GIT COMMANDS \033[0m"
  echo -e "\033[1m gcof \033[0m  Create new JIRA ticket branch - git checkout -b <user>-*"
  echo -e "\033[1m gcop \033[0m  Checkout existing JIRA ticket - git checkout <user>-*"
  echo -e "\033[1m gcim \033[0m  Commit with JIRA ticket - git commit -m 'SUMO-* '"
  echo -e "\033[1m gpoh \033[0m  Push current branch - git push origin HEAD"
  echo -e "\033[1m ga \033[0m    git add"
  echo -e "\033[1m ga. \033[0m   git add ."
  echo -e "\033[1m gd \033[0m    git diff"
  echo -e "\033[1m gs \033[0m    git status"
  echo -e "\033[1m gb \033[0m    git branch"
  echo -e "\033[1m gco \033[0m   git checkout"
  echo -e "\033[1m gcom \033[0m  git checkout master"
  echo -e "\033[1m gl \033[0m    git pull"

  echo -e ""
  echo -e "\033[1m JIRA COMMANDS \033[0m"
  echo -e "\033[1m jira [issue]\033[0m  Get Jira Summary of current/asked ticket"
  echo -e "\033[1m jira link [issue]\033[0m Get link to current/asked ticket"
  echo -e "\033[1m jira open [issue]\033[0m Open the current/asked ticket in chrome"
}
jira(){
  if [ "$2" == "" ]
  then
    current_issue=$(getissue);
  else
    current_issue=$2;
  fi

  case "$1" in
  "")
    echo $(getIssueSummary ${current_issue});
    ;;
  "link")
    echo "https://admitkard.atlassian.net/browse/${current_issue}";
    ;;
  "open")
    open "https://admitkard.atlassian.net/browse/${current_issue}";
    ;;
  *)
    echo $(getIssueSummary ${1});
    ;;
  esac
}
getissue(){
  [[ $(git symbolic-ref --short HEAD) =~ $USER-([A-Za-z]+-[0-9]+).*$ ]];
  echo "${BASH_REMATCH[1]}";
}

getIssueSummary(){
  local jiralink="https://admitkard.atlassian.net/rest/api/3/issue/${1}";
  local curl_out=$(curl -s -u $JIRA_USER:$JIRA_PASS -X GET -H \"Content-Type: application/json\" $jiralink?fields=summary,status,priority);
  local jq_status=$(echo $curl_out | jq -r '. | "\\033[100;1m \(.fields.status.name) \\033[0m"');
  local jq_priority=$(echo $curl_out | jq -r '.fields.priority.id');
  local jq_summary=$(echo $curl_out | jq -r '.fields.summary');
  echo -e $jq_status$(getJiraPriorityIcon $jq_priority)$jq_summary;
}

getJiraPriorityIcon(){
  case "$1" in
  "1")
    echo "\033[31;1m ⌀ \033[0m";
    ;;
  "2")
    echo '\033[31;1m ⇡ \033[0m';
    ;;
  "3")
    echo "\033[31;1m ▲ \033[0m";
    ;;
  "4")
    echo "\033[32;1m ▼ \033[0m";
    ;;
  "5")
    echo "\033[37;1m ↡ \033[0m";
  esac
}
