---
name: Pydantic v2 migration
description: v2: @field_validator not @validator. model_rebuild() for forward refs. .dict() → .model_dump().
type: reference
---

Key changes from Pydantic v1 to v2:

- `@validator` → `@field_validator(mode='before'|'after')`
- `__root__` → `RootModel[T]`
- Forward refs: call `MyModel.model_rebuild()` after all referenced classes are defined
- `.dict()` → `.model_dump()`
- `.json()` → `.model_dump_json()`

**Common failure:** forgetting `model_rebuild()` causes `PydanticUserError` at import time on models with circular refs.
