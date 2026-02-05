# Technical Specifications

## System Architecture
- Planner-Worker-Judge pattern
- All external connections via MCP
- PostgreSQL for structured data
- Weaviate for semantic memory
- Redis for caching and queues

## API Examples

### Create Task:
```json
{
  "task_id": "uuid",
  "type": "generate_content",
  "topic": "summer fashion",
  "platform": "instagram"
}
