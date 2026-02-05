# Skill: Content Generate

## Purpose
This skill generates text or media content aligned with the agent persona, campaign goal, and current trends.

## When Used
- After trend selection
- When Planner assigns content creation
- When engagement replies are required

## Inputs
- topic: string
- content_type: string (post, caption, reply, script)
- persona_context: object
- platform: string

## Outputs
- generated_content: string or media prompt
- confidence_score: float
- persona_alignment_flag: boolean

## MCP Dependencies
- MCP Tool: text_generation
- MCP Tool: image_generation (optional)
- MCP Resource: persona_memory

## Constraints & Safety
- Must follow persona voice and directives
- Must avoid sensitive topics unless approved
- Must include disclosure markers when required
