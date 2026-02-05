# Chimera Agent Skills

## Skill 1: trend_research
**Purpose**: Find trending topics
**Input**: Niche, timeframe, max_results
**Output**: List of trends with relevance scores
**Tools**: Twitter MCP, News MCP, Google Search MCP

## Skill 2: content_generation
**Purpose**: Create social media content
**Input**: Topic, platform, tone, media requirements
**Output**: Text, images, videos with metadata
**Tools**: Image Generation MCP, Video MCP, LLM

## Skill 3: social_engagement
**Purpose**: Interact with followers
**Input**: Message, user history, relationship level
**Output**: Appropriate response
**Tools**: Platform MCPs, Memory MCP

## Skill Structure
Each skill should have:
- Clear input/output schema
- Error handling
- Performance metrics
- Testing coverage
