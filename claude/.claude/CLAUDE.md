# General Rules

- Never use emojis in code, comments, log messages, or any generated output.

# Python Development

- Always use f-strings for string formatting.
- After running pytest, always follow up with pytest-cov to check coverage.
- If encountering authentication issues when installing packages:
  - **Poetry projects:** run `export POETRY_HTTP_BASIC_EVENUP_PASSWORD=$(gcloud auth print-access-token)`
  - **uv projects:** run `export UV_INDEX_URL=https://oauth2accesstoken:$(gcloud auth print-access-token)@us-central1-python.pkg.dev/evenup-infra/evenup-python/simple/`
