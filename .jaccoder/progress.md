# Project: emergency-immigrant-aid
## Status: DONE
## Plan
1. [x] Review Jac fullstack and styling docs
2. [x] Inspect existing app structure
3. [x] Add global Tailwind styling and wire it in main.jac
4. [x] Replace starter frontend with emergency legal aid landing experience
5. [x] Browser-validate and fix runtime issues
## Files
- jac.toml — project config with Vite + Tailwind plugin
- main.jac — app entry point with global CSS import
- frontend.cl.jac — emergency legal aid UI with scenario switching
- styles/global.css — Tailwind theme and base styles
## Issues
- Initial frontend compile failed due to inline JSX lambda/comprehension syntax; fixed by using named handlers and explicit step cards
## Learnings
- Named def handlers are safest for onClick in .cl.jac
- Explicit JSX blocks are more reliable than complex inline list comprehensions for quick live-preview builds
## Last Action
Finished the emergency legal aid landing page and ran browser validation.