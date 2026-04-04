# preview-template

A Jac client-side application with React support.

## Project Structure

```
preview-template/
├── jac.toml              # Project configuration
├── main.jac              # Main application entry
├── frontend.cl.jac       # Client-side app (React/JSX in Jac)
├── components/           # Reusable components (.cl.jac)
├── assets/               # Static assets (images, fonts, etc.)
├── styles/               # Global/theme styling       
```

## Getting Started

Start the development server:

```bash
jac start main.jac
```

## Components

Create Jac components in `components/` as `.cl.jac` files and import them:

```jac
cl import from .components.Button { Button }
```

## Adding Dependencies

Add npm packages with the --cl flag:

```bash
jac add --cl react-router-dom
```
