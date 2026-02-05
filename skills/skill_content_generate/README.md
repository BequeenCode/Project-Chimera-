# Skill: Trend Fetch

## Purpose
This skill retrieves current trending topics and signals from external sources so the agent can create relevant and timely content.

## When Used
- When the Planner assigns a trend discovery task
- Before content generation
- During periodic environment scanning

## Inputs
- source: string (news, social, market)
- timeframe: string (hourly, daily, weekly)
- niche_filter: optional string

## Outputs
- list of trend items
  - topic
  - source
  - timestamp
  - relevance_score

## MCP Dependencies
- MCP Resource: news://latest
- MCP Resource: social://trends
- MCP Tool: search_trends

## Constraints & Safety
- Must not fabricate trend data
- Must only use MCP-approved sources
- If source unavailable, return structured error
