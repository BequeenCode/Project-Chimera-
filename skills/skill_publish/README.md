# Skill: Publish Content

## Purpose
This skill publishes approved content to a target social platform through MCP tools.

## When Used
- After Judge approval
- After HITL approval if required
- When task status = approved

## Inputs
- platform: string (twitter, instagram, threads)
- text_content: string
- media_urls: optional list
- disclosure_level: string

## Outputs
- publish_status: success | failed
- platform_post_id: string
- timestamp: datetime

## MCP Dependencies
- MCP Tool: post_content
- MCP Tool: upload_media

## Constraints & Safety
- Must not publish without approval status
- Must respect platform rate limits
- Must include AI disclosure flags where supported
