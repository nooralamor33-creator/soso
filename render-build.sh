#!/usr/bin/env bash
set -e

echo "==> Installing pnpm..."
npm install -g pnpm --prefer-offline 2>/dev/null || npm install -g pnpm

echo "==> Installing dependencies..."
pnpm install --frozen-lockfile

echo "==> Building shared libraries..."
pnpm run typecheck:libs

echo "==> Building frontend..."
BASE_PATH=/ pnpm --filter @workspace/game-auth run build

echo "==> Copying frontend build to API server public dir..."
mkdir -p artifacts/api-server/public
cp -r artifacts/game-auth/dist/public/. artifacts/api-server/public/

echo "==> Building API server..."
pnpm --filter @workspace/api-server run build

echo "==> Build complete!"
