# Technical Specification — Project Chimera

## Agent Architecture
The system uses a Planner–Worker–Judge pattern.
- Planner: breaks goals into tasks
- Worker: executes atomic tasks
- Judge: validates output and enforces policies

## Task Schema (Draft)

```json
{
  "task_id": "string",
  "task_type": "string",
  "priority": "high | medium | low",
  "input": "object",
  "status": "pending | in_progress | review | complete"
}
