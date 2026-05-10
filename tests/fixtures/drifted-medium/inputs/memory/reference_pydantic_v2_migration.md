---
name: Pydantic v2 migration
description: v2 validators use @field_validator not @validator. model_rebuild() needed for forward refs.
type: reference
---

All projects now use Pydantic v2. Key migration changes:

- `@validator` → `@field_validator` (with `mode='before'` or `mode='after'`)
- `__root__` models → use `RootModel[T]`
- Forward references: call `MyModel.model_rebuild()` after all referenced classes are defined
- `.dict()` → `.model_dump()`
- `.json()` → `.model_dump_json()`

**Common failure:** forgetting `model_rebuild()` on models with circular refs causes `PydanticUserError` at import time.
