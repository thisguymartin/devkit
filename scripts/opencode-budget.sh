#!/usr/bin/env bash
set -e

# OpenCode Zen Budget Tracker
# Displays model pricing reference and budget allocation for the $100/mo plan.
# For actual spend tracking, use the tokenscope plugin in OpenCode.

BOLD="\033[1m"
DIM="\033[2m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${BOLD}OpenCode + Copilot Pro — Budget Reference${RESET}"
echo -e "${DIM}Total: \$100/mo — Copilot Pro \$10 + OpenCode Zen \$90${RESET}"
echo ""

echo -e "${BOLD}Copilot Pro (\$10/mo — included)${RESET}"
echo -e "  ${GREEN}Inline completions${RESET}  Unlimited    Neovim tab-complete"
echo -e "  ${GREEN}Quick chat${RESET}          300 reqs     Premium request quota"
echo -e "  ${GREEN}PR review${RESET}           Free         Assign Copilot as reviewer"
echo -e "  ${GREEN}Copilot CLI${RESET}         Free         Explore + Task agents"
echo ""

echo -e "${BOLD}OpenCode Zen (\$90/mo budget)${RESET}"
echo ""
echo -e "${CYAN}Think Mode (Planning)${RESET}"
echo -e "  Gemini 3.1 Pro      \$2/\$12 per 1M    Default planner, 1M context"
echo -e "  GPT 5.4             \$2.50/\$15 per 1M  Second opinion, plan review"
echo ""
echo -e "${CYAN}Build Mode (Doing)${RESET}"
echo -e "  GPT 5.4             \$2.50/\$15 per 1M  Default builder, Go/TS"
echo -e "  GPT 5.3 Codex       \$1.75/\$14 per 1M  Autonomous test-fix loops"
echo -e "  GLM 5               \$1/\$3.20 per 1M   Budget builder (~80% quality)"
echo -e "  Kimi K2.5           \$0.60/\$3 per 1M   Frontend/vision-to-code"
echo -e "  GPT 5.4 Mini        \$0.75/\$4.50 per 1M Lightweight orchestration"
echo ""
echo -e "${CYAN}Bulk (Grunt Work)${RESET}"
echo -e "  ${GREEN}MiniMax M2.5 Free${RESET}   FREE             Tests, docs, boilerplate"
echo -e "  ${GREEN}Qwen3.6 Plus Free${RESET}   FREE             Alternative free model"
echo -e "  ${GREEN}Big Pickle${RESET}          FREE             Experimental"
echo -e "  MiniMax M2.5 (paid) \$0.30/\$1.20 per 1M Fallback"
echo -e "  Gemini 3 Flash      \$0.50/\$3 per 1M   Docs/READMEs"
echo -e "  GPT 5.4 Nano        \$0.20/\$1.25 per 1M Git ops, trivial"
echo ""

echo -e "${BOLD}Monthly Allocation Target${RESET}"
echo -e "  Architecture/planning  ~\$15  (Gemini 3.1 Pro)"
echo -e "  Implementation         ~\$40  (GPT 5.4 / Codex)"
echo -e "  Budget implementation  ~\$10  (GLM 5 / Kimi K2.5)"
echo -e "  Code review (deep)     ~\$8   (Gemini 3.1 Pro)"
echo -e "  Tests/docs/bulk        ~\$0   (Free models)"
echo -e "  Buffer                 ~\$17"
echo -e "  ${BOLD}Total Zen:             ~\$90${RESET}"
echo ""

echo -e "${YELLOW}Tip:${RESET} Use 'opencode plugin tokenscope' for per-session cost tracking."
echo -e "${YELLOW}Tip:${RESET} Check Zen console weekly to eyeball spend."
echo -e "${YELLOW}Tip:${RESET} Set Zen monthly limit to \$90, disable auto-reload."
