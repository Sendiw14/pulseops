import { NextResponse } from "next/server";

export function GET() {
  return NextResponse.json({ status: "ok", service: "pulseops-web", mode: "demo", timestamp: new Date().toISOString() });
}
