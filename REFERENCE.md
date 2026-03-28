# Agency Automation Stack — Complete Reference

> This document contains everything needed to understand, set up, and operate a self-hosted agency sales & marketing automation system running 24/7 on a spare laptop. Give this to any Claude Code instance or AI assistant for full context.

---

## TABLE OF CONTENTS

1. [What This Is](#1-what-this-is)
2. [Architecture Overview](#2-architecture-overview)
3. [The 4 Core Services](#3-the-4-core-services)
4. [The Full Tool Ecosystem](#4-the-full-tool-ecosystem)
5. [Lead Scraping Tools](#5-lead-scraping-tools)
6. [LinkedIn Outreach Automation](#6-linkedin-outreach-automation)
7. [Personal Branding & Auto-Posting](#7-personal-branding--auto-posting)
8. [Carousel Creation (LinkedIn + Instagram)](#8-carousel-creation-linkedin--instagram)
9. [Content Planning & AI Content Generation](#9-content-planning--ai-content-generation)
10. [Cold Email Outreach](#10-cold-email-outreach)
11. [CRM Systems](#11-crm-systems)
12. [AI Chatbots & Lead Capture](#12-ai-chatbots--lead-capture)
13. [Browser Automation & RPA](#13-browser-automation--rpa)
14. [Workflow Orchestration Platforms](#14-workflow-orchestration-platforms)
15. [Local AI Models (Ollama)](#15-local-ai-models-ollama)
16. [Local Image Generation](#16-local-image-generation)
17. [n8n Workflow Examples](#17-n8n-workflow-examples)
18. [Email Deliverability Setup](#18-email-deliverability-setup)
19. [LinkedIn Safety Rules](#19-linkedin-safety-rules)
20. [Hardware Requirements](#20-hardware-requirements)
21. [Cost Comparison](#21-cost-comparison)
22. [Setup Instructions](#22-setup-instructions)
23. [Daily Automation Flow](#23-daily-automation-flow)
24. [Expansion Roadmap](#24-expansion-roadmap)

---

## 1. WHAT THIS IS

A self-hosted automation stack that runs on a spare laptop 24/7 to handle an agency's sales and marketing. It replaces $500-1,500/month in SaaS tools with open-source alternatives at near-zero cost.

**What it automates:**
- Lead discovery and scraping (LinkedIn, directories, Google Maps)
- LinkedIn outreach (connection requests, DM follow-ups, personalized messages)
- Personal branding (auto-posting to LinkedIn, Instagram, X, Facebook, TikTok)
- Content creation (AI-generated posts, carousels, email copy)
- Cold email sequences (multi-step drip campaigns)
- CRM tracking (deal pipeline, contact management)
- Lead enrichment (finding emails, company data from names)

**Who it's for:** Agency owners who want to automate the sales/marketing grind — lead gen, outreach, content — so they can focus on closing deals and delivering work.

---

## 2. ARCHITECTURE OVERVIEW

```
┌─────────────────────────────────────────────────────────────┐
│                    SPARE LAPTOP (24/7)                       │
│                                                             │
│  ┌─────────────┐  ┌──────────────┐  ┌───────────────────┐  │
│  │   n8n        │  │  Ollama      │  │  Open WebUI       │  │
│  │  :5678       │  │  :11434      │  │  :3000            │  │
│  │  Orchestrator│  │  Local AI    │  │  Chat Interface   │  │
│  └──────┬───────┘  └──────┬───────┘  └───────────────────┘  │
│         │                 │                                  │
│  ┌──────┴───────┐  ┌──────┴───────┐                         │
│  │ OpenOutreach  │  │   Postiz     │                         │
│  │ :6080 / :8000│  │  :4007       │                         │
│  │ LinkedIn Bot  │  │ Social Sched │                         │
│  └──────────────┘  └──────────────┘                         │
│                                                             │
│  Supporting: PostgreSQL x3, Redis, Temporal, Elasticsearch  │
└─────────────────────────────────────────────────────────────┘
```

**Data flow:**
```
OpenOutreach finds leads on LinkedIn
    → n8n moves leads into pipeline
    → Ollama writes personalized content (free)
    → Postiz publishes across all social platforms
    → Owner checks dashboards → closes deals
```

---

## 3. THE 4 CORE SERVICES

### 3a. n8n — Workflow Orchestration (The Brain)
- **URL:** http://localhost:5678
- **What:** Visual drag-and-drop workflow builder with 400+ integrations
- **Why:** Connects everything together. Schedules tasks, moves data between tools, triggers automations.
- **GitHub:** https://github.com/n8n-io/n8n (100k+ stars)
- **Key integrations:** Gmail, Google Sheets, Slack, HubSpot, LinkedIn, HTTP Request, OpenAI, Claude, Ollama
- **Self-hosted:** Docker, unlimited executions, fair-code license

### 3b. OpenOutreach — LinkedIn Lead Gen + Outreach
- **URL:** http://localhost:6080/vnc.html (VNC viewer) / http://localhost:8000/admin/ (CRM)
- **What:** Describe your product + target market → AI finds leads on LinkedIn → qualifies them → sends connection requests → follows up via DM
- **Why:** Fully autonomous LinkedIn prospecting. Set it and forget it.
- **GitHub:** https://github.com/eracle/OpenOutreach
- **How it works:**
  - Playwright + stealth plugins mimic real user behavior
  - Gaussian Process ML model learns your ideal customer profile over time (explore/exploit)
  - LLM qualification of leads (GPT-4, Claude, or any OpenAI-compatible endpoint)
  - Profile states: QUALIFIED → READY_TO_CONNECT → PENDING → CONNECTED → COMPLETED
  - Built-in Django CRM for tracking
- **Config needed:** LinkedIn email + password, LLM API key, product description, campaign objective
- **Safety defaults:** 50 connects/day, 250/week, randomized delays (5-8s), active hours 10am-8pm

### 3c. Postiz — Social Media Scheduler + AI Content
- **URL:** http://localhost:4007
- **What:** Schedule and publish content across 20+ platforms with AI copilot
- **Why:** Replaces Buffer/Hootsuite. Content calendar, team collab, analytics. Free when self-hosted.
- **GitHub:** https://github.com/gitroomhq/postiz-app
- **Platforms:** LinkedIn, Instagram, X, Facebook, Threads, Reddit, TikTok, YouTube, Pinterest, Discord, Slack, Mastodon, Bluesky
- **Key features:** AI copilot for post ideas/copy, RSS auto-post, content templates, calendar view, API + webhooks
- **Requires:** Social media API keys for each platform you want to connect

### 3d. Ollama + Open WebUI — Local AI (Zero Cost)
- **Ollama API:** http://localhost:11434
- **Open WebUI:** http://localhost:3000
- **What:** Run AI models locally. Open WebUI gives a ChatGPT-like interface.
- **Why:** Generate content, write emails, score leads, brainstorm — all free, all private, all offline.
- **GitHub:** https://github.com/ollama/ollama / https://github.com/open-webui/open-webui
- **Recommended models:**
  - `llama3.1:8b` — Fast general purpose (12GB RAM)
  - `gemma2:27b` — Best for copywriting (24GB RAM)
  - `qwen2.5:32b` — Coding + writing hybrid (24GB RAM)
  - `mistral:7b` — Fast, multilingual (10GB RAM)
- **Open WebUI features:** Multiple model switching, RAG (upload docs and chat with them), system prompt presets, conversation history, web search augmentation

---

## 4. THE FULL TOOL ECOSYSTEM

Beyond the 4 core services, here is every tool researched across 7 parallel research agents, categorized by function. These can be added to the stack as needed.

---

## 5. LEAD SCRAPING TOOLS

| Tool | Type | What It Does | GitHub / Link |
|------|------|-------------|---------------|
| **tomquirk/linkedin-api** | Python library | Wraps LinkedIn's internal Voyager API. Search profiles, get data, send messages. No browser needed. | https://github.com/tomquirk/linkedin-api |
| **LinkedInDumper** | Python script | Dumps all employees of a target company from LinkedIn | https://github.com/l4rm4nd/LinkedInDumper |
| **joeyism/linkedin_scraper** | Selenium-based | Scrapes LinkedIn profile data (name, experience, education, skills) | https://github.com/joeyism/linkedin_scraper |
| **drissbri/linkedin-scraper** | FastAPI + Selenium | Self-hosted REST API for LinkedIn data extraction | https://github.com/drissbri/linkedin-scraper |
| **LinkedIn Sales Nav Scraper** | Chrome extension | Extracts leads from Sales Navigator search results | https://github.com/qtecsolution/Linkedin-Sales-Navigator-Scraper |
| **theHarvester** | OSINT tool | Finds emails, subdomains, names from a domain via Google/Bing/etc. | https://github.com/laramies/theHarvester |
| **buster** | OSINT tool | Advanced email reconnaissance — finds emails and social media from a name | https://github.com/sham00n/buster |
| **CrossLinked** | Enumeration | Extracts employee names from LinkedIn via search engine scraping (no LinkedIn login needed) | https://github.com/m8sec/CrossLinked |
| **Fire Enrich** | AI enrichment | Upload CSV with emails → AI agents fill in company data, funding, tech stack, decision makers. Open-source Clay alternative. | https://github.com/firecrawl/fire-enrich |
| **Firecrawl** | Web scraper | Turns any website URL into clean structured data (markdown/JSON). 40k+ stars. | https://github.com/mendableai/firecrawl |
| **Crawlee** | Scraping framework | Unified Puppeteer/Playwright scraper with anti-bot features, proxy rotation, session management | https://github.com/apify/crawlee |
| **Scrapy** | Scraping framework | The classic Python web scraper. Async, fast, handles millions of pages. 54k+ stars. | https://github.com/scrapy/scrapy |
| **Reacher** | Email verification | Open-source email verification in Rust. Checks SMTP deliverability without sending. | https://github.com/reacherhq/check-if-email-exists |

---

## 6. LINKEDIN OUTREACH AUTOMATION

| Tool | What It Does | GitHub |
|------|-------------|--------|
| **OpenOutreach** (core stack) | Full pipeline: discover → qualify → connect → AI follow-up → CRM | https://github.com/eracle/OpenOutreach |
| **Harddiikk/Linkedin-Outreach** | Profile visits, connection requests, AI-personalized messaging | https://github.com/Harddiikk/Linkedin-Outreach |
| **joshiayush/inb** | Automates connections, messaging, endorsements via Voyager API (no browser) | https://github.com/joshiayush/inb |
| **socioboard/inboard** | Desktop app for LinkedIn marketing, multi-account management | https://github.com/socioboard/inboard |
| **SalesGPT** | AI sales agent — understands sales conversation stages, works across email/SMS/WhatsApp/voice | https://github.com/filip-michalsky/SalesGPT |
| **OpenSDR** | CLI agent that automates research and outbound lead generation | https://github.com/MatthewDailey/open-sdr |
| **AI-SDR (n8n)** | n8n workflow: lead gen + qualification + outreach with Gemini | https://github.com/AntraTripathi74/AI-SDR |
| **BrightData AI-SDR-BDR** | Full BDR system: discovery, trigger detection, contact research, outreach | https://github.com/brightdata/ai-sdr-bdr-agent |

**LinkedIn safety rules:**
- Use a secondary/burner account for automation
- Max 20-30 connection requests/day (start at 10% for first 2 weeks)
- Randomize delays by 20-30%
- Mix activities (likes, comments, profile views — not just outreach)
- Withdraw pending invites regularly
- Use a dedicated IP (home IP is fine for single account)
- Premium/Sales Navigator accounts get warnings first; free accounts get banned overnight

---

## 7. PERSONAL BRANDING & AUTO-POSTING

| Tool | What It Does | GitHub |
|------|-------------|--------|
| **Postiz** (core stack) | Full scheduler for 20+ platforms with AI copilot | https://github.com/gitroomhq/postiz-app |
| **Mixpost** | Self-hosted Buffer alternative. MIT licensed. | https://github.com/inovector/mixpost |
| **CRAKZOR/linkedin-post-automator** | Scrapes industry news → ChatGPT writes posts → auto-publishes on schedule | https://github.com/CRAKZOR/linkedin-post-automator |
| **bhaskarblur/Linkedin-Post-Automation** | AI generates ideas → creates images → sends to Telegram for approval → posts | https://github.com/bhaskarblur/Linkedin-Post-Automation |
| **tanishra/Linkedin-Post-Automation** | n8n workflow: Google Sheets ideas → AI content → LinkedIn publish → email report | https://github.com/tanishra/Linkedin-Post-Automation |
| **joeygoesgrey/linkedin-bot** | Selenium bot for scheduled LinkedIn posting with media and tags | https://github.com/joeygoesgrey/linkedln-bot |

---

## 8. CAROUSEL CREATION (LINKEDIN + INSTAGRAM)

| Tool | What It Does | GitHub |
|------|-------------|--------|
| **carousel-generator** | AI-powered LinkedIn carousel maker, outputs PDF. Next.js, MIT. | https://github.com/FranciscoMoretti/carousel-generator |
| **slidev-linkedin-carousel** | Write in Markdown → export to carousel PDF | https://github.com/Open-reSource/slidev-theme-linkedin-carousel |
| **carousel-linked-in** | Auto-upload carousel documents to LinkedIn via API | https://github.com/BleedingDev/carousel-linked-in |
| **linkedin-post-generator** | Creates LinkedIn carousel posts programmatically | https://github.com/RavenColEvol/linked_in-post-generator |
| **substack-to-instagram** | Transforms blog posts into Instagram carousel images | https://github.com/gvmfhy/substack-to-instagram |
| **instagram-publisher** | Publishes Instagram images, slideshows, reels, stories via Node.js | https://github.com/yuvraj108c/instagram-publisher |
| **instagrapi** | Fastest Python library for Instagram Private API. Posts, carousels, reels, stories. | https://github.com/subzeroid/instagrapi |
| **upload-post SDK** | Multi-platform posting Python SDK | https://github.com/upload-post/upload-post-pip |

**n8n carousel workflow templates:**
- Auto-Generate LinkedIn Carousels with Gemini AI + PostNitro: https://n8n.io/workflows/7733
- Branded LinkedIn Carousels with GPT-4o-mini + Figma Templates: https://n8n.io/workflows/9455
- Instagram Carousel Posts via Google Sheets + Cloudinary: https://n8n.io/workflows/5833
- Generate & Publish Carousels with GPT-Image-1: https://n8n.io/workflows/4028

---

## 9. CONTENT PLANNING & AI CONTENT GENERATION

### Self-Hosted Scheduling Platforms
| Tool | What It Does | GitHub |
|------|-------------|--------|
| **Postiz** | Full scheduler + AI copilot, 20+ platforms | https://github.com/gitroomhq/postiz-app |
| **Mixpost** | Buffer alternative, MIT, content calendar | https://github.com/inovector/mixpost |
| **Socioboard 5.0** | 9 social networks, team management | https://github.com/socioboard/Socioboard-5.0 |

### Local AI Content Generation (Zero Cost)
- **Ollama + Open WebUI** — Run models locally, create system prompt presets for different content types
- **n8n + Ollama integration** — Automate daily/weekly content generation on a schedule
- **Self-Hosted AI Starter Kit** — Docker bundle of n8n + Ollama + Qdrant: https://github.com/n8n-io/self-hosted-ai-starter-kit

### Recommended System Prompts (Save as Presets in Open WebUI)

**LinkedIn Post Writer:**
```
You are a LinkedIn ghostwriter for a {niche} business owner. Write posts that:
- Open with a hook (first line gets the click)
- Use short paragraphs (1-2 sentences)
- Include a clear CTA
- Sound human, not corporate
- 150-250 words max
```

**Cold Email Writer:**
```
You write cold emails for a {service} agency targeting {ICP}. Rules:
- Under 150 words
- Plain text only (no HTML, no images)
- Personalized opening referencing their specific situation
- One clear CTA (reply or book a call)
- Conversational tone, not salesy
```

**Lead Scorer:**
```
Score this lead 1-10 for fit with our {service} business.
Company info: {info}
Score on: company size (prefer 10-200 employees), industry fit, tech adoption signals, growth indicators.
Return: Score (1-10), 2-sentence reasoning, suggested outreach angle.
```

---

## 10. COLD EMAIL OUTREACH

| Tool | What It Does | GitHub |
|------|-------------|--------|
| **Mautic** | Full marketing automation: visual campaigns, drip sequences, lead scoring, landing pages | https://github.com/mautic/mautic |
| **Postal** | Open-source SMTP server. Bounce handling, DKIM signing, open/click tracking, multi-domain. | https://github.com/postalserver/postal |
| **listmonk** | High-performance newsletter sender. Handles millions of subs. 64MB RAM. NOT for cold outreach (no sequences). | https://github.com/knadh/listmonk |
| **BillionMail** | All-in-one: mail server + newsletter + marketing. Has built-in IP warmup. Docker. | https://github.com/Billionmail/BillionMail |
| **Coldflow** | Purpose-built for cold email: warmup, sequences, deliverability tracking | https://github.com/pypes-dev/coldflow |
| **Dittofeed** | Omni-channel: email + SMS + WhatsApp + push. YC-backed, MIT. | https://github.com/dittofeed/dittofeed |
| **MauticColdEmailOutreachBundle** | Plugin that adds cold-email features to Mautic (throttling, reply detection) | https://github.com/karser/MauticColdEmailOutreachBundle |

### Recommended Cold Email Stack
**Mautic + Postal** on a separate $20-40/month VPS (not on the laptop — keep email infrastructure separate).

### Multi-Domain Strategy (Critical)
- Buy 3-5 similar domains (e.g., `youragency.io`, `youragency.co`)
- Never use your main business domain for cold outreach
- Set up SPF/DKIM/DMARC on each
- Create 2-3 inboxes per domain
- Warm up each inbox for 4+ weeks before sending
- Max 40-50 emails per inbox per day
- Rotate domains; rest them for 4-6 weeks after 4-6 months

---

## 11. CRM SYSTEMS

| Tool | Best For | GitHub |
|------|----------|--------|
| **OpenOutreach CRM** (built-in) | LinkedIn lead tracking, already in the stack | Part of OpenOutreach |
| **Twenty CRM** | Modern UI, best for tech-savvy users. Salesforce alternative. 25k+ stars. | https://github.com/twentyhq/twenty |
| **EspoCRM** | Small agencies. Built-in email client, workflow automation, lightweight. Best overall for solo agency. | https://www.espocrm.com/ |
| **Erxes** | All-in-one: CRM + marketing + support. Replaces HubSpot. | https://github.com/erxes/erxes |
| **Frappe CRM** | If you also need invoicing/accounting (integrates with ERPNext) | https://github.com/frappe/crm |
| **SuiteCRM** | Enterprise needs. Overkill for solo operator. | https://suitecrm.com/ |

---

## 12. AI CHATBOTS & LEAD CAPTURE

| Tool | What It Does | GitHub |
|------|-------------|--------|
| **Typebot** | Visual chatbot builder for lead capture on your website. Open-source Typeform. | https://github.com/baptisteArno/typebot.io |
| **Chatwoot** | Live chat widget + AI agent. Handles WhatsApp, Instagram, Telegram, email. 22k+ stars. | https://github.com/chatwoot/chatwoot |
| **Flowise** | Drag-and-drop LLM chatbot builder. RAG pipelines. Works with Ollama. 35k+ stars. | https://github.com/FlowiseAI/Flowise |
| **LangFlow** | Visual AI workflow builder on LangChain. 45k+ stars. | https://github.com/langflow-ai/langflow |

---

## 13. BROWSER AUTOMATION & RPA

| Tool | What It Does | GitHub |
|------|-------------|--------|
| **Browser-Use** | AI browser agent — give tasks in plain English, it controls a browser. 78k+ stars. | https://github.com/browser-use/browser-use |
| **Skyvern** | AI browser automation using LLMs + computer vision. Works on unknown websites. | https://github.com/Skyvern-AI/skyvern |
| **Stagehand** | Production-grade AI browser automation. Auto-caches: first run uses AI, repeats are free. MIT. | https://github.com/browserbase/stagehand |
| **Camoufox** | Anti-detect Firefox browser. Fingerprint spoofing at C++ level. Fully undetectable. | https://github.com/daijro/camoufox |
| **Playwright** | Microsoft's browser automation framework. Foundation for most AI tools. | https://github.com/microsoft/playwright |
| **Puppeteer + Stealth** | Headless Chrome automation with stealth plugin to avoid detection | puppeteer-extra-plugin-stealth |
| **LaVague** | AI web agent framework (development slowed since Jan 2025, not recommended for new projects) | https://github.com/lavague-ai/LaVague |

---

## 14. WORKFLOW ORCHESTRATION PLATFORMS

| Platform | License | Integrations | Best For | GitHub |
|----------|---------|-------------|----------|--------|
| **n8n** (recommended) | Source-available | 400+ | Technical users, complex AI workflows | https://github.com/n8n-io/n8n |
| **Activepieces** | MIT (fully open) | 510+ | Non-technical teams, simpler UI | https://github.com/activepieces/activepieces |
| **Huginn** | MIT | ~50 agents | Web monitoring, scraping, event-driven | https://github.com/huginn/huginn |
| **Automatisch** | AGPL | ~60-80 | Zapier refugees wanting self-hosted | https://github.com/automatisch/automatisch |

---

## 15. LOCAL AI MODELS (OLLAMA)

### Best Models by Task

| Task | Model | RAM Needed | Quality vs GPT-4 |
|------|-------|-----------|-------------------|
| Quick drafts, email replies | Llama 3.1 8B | 12GB | ~60-65% |
| LinkedIn posts, copywriting | Gemma 2 27B | 24GB | ~75% |
| Structured output, analysis | Mistral Small 24B | 20GB | ~75% |
| Coding + writing hybrid | Qwen 2.5 32B | 24GB | ~80% |
| Best local general purpose | Llama 3.3 70B | 48GB+ | ~85-90% |
| Lead scoring, classification | Any 8B+ model | 12GB | ~70% (structured tasks) |

### What Local AI Is Good For
- Volume content generation (generate 10 drafts, pick the best)
- Lead research and scoring (structured analysis)
- First drafts of everything (proposals, posts, emails)
- Privacy-sensitive work (client data never leaves the machine)
- Cost savings at scale (500+ content pieces/month)

### What Local AI Is NOT Good For
- Final-quality persuasive copy (use GPT-4o or Claude for that)
- Complex coding projects (use cloud models)
- Text rendering in images (unreliable — use Canva/Figma for overlays)
- Real-time information (no internet access unless web search is added)
- Client-facing chatbots (latency and quality not production-grade)

### Installation
```bash
brew install ollama                    # macOS
ollama pull llama3.1:8b               # Pull a model
ollama run llama3.1:8b                # Interactive chat
# API available at http://localhost:11434
```

---

## 16. LOCAL IMAGE GENERATION

| Tool | What It Does | Best For | GitHub |
|------|-------------|----------|--------|
| **ComfyUI** | Node-based AI image gen UI. Batch workflows, API access. | Complex pipelines, automation | https://github.com/comfyanonymous/ComfyUI |
| **AUTOMATIC1111** | Most popular Stable Diffusion web UI | Simpler setup, plugin ecosystem | https://github.com/AUTOMATIC1111/stable-diffusion-webui |
| **Fooocus** | Simplified SD interface | Quick image gen, minimal config | https://github.com/lllyasviel/Fooocus |

### Image Gen Speed by Hardware
| Hardware | SDXL | FLUX.1 Schnell | FLUX.1 Dev |
|----------|------|----------------|------------|
| MacBook Air M2 16GB | 15-30s | 30-60s | 2-5min |
| MacBook Pro M3 Pro 36GB | 5-10s | 10-20s | 45-90s |
| Gaming laptop RTX 4060 8GB | 3-8s | 5-10s | 20-40s |
| Gaming laptop RTX 4090 16GB | 1-3s | 2-4s | 8-15s |

### What Works for Agencies
- Abstract backgrounds for carousel slides
- Lifestyle imagery (offices, people working)
- Pattern/texture backgrounds for quote graphics
- NOT text in images (add text in Canva/Figma instead)
- NOT exact brand logos or specific brand elements

---

## 17. N8N WORKFLOW EXAMPLES

### Workflow A: Daily Lead Finder
```
Schedule (7 AM) → Apify scrapes Google Maps for target businesses
→ Apollo.io enriches with emails → OpenAI scores leads 1-10
→ Google Sheets writes qualified leads → Slack notification
```

### Workflow B: LinkedIn Content Posting
```
Schedule (Mon/Wed/Fri 9 AM) → Read content idea from Google Sheets
→ Claude/GPT generates LinkedIn post → LinkedIn API publishes
→ Wait 24hr → Fetch engagement metrics → Write back to Sheets
```

### Workflow C: Cold Email Sequence
```
Google Sheets trigger (new lead) → HTTP scrapes their website
→ OpenAI writes 3-email sequence → SMTP sends Email 1
→ Wait 3 days → Check for reply → If no reply: send Email 2
→ Wait 4 days → Send Email 3 → Update status in Sheets
```

### Workflow D: Reply Classifier
```
IMAP trigger (new reply) → OpenAI classifies: Interested / Not Interested / Question / OOO
→ IF Interested: Slack alert + CRM deal created + calendar link sent
→ IF Question: AI drafts response, holds for human review
→ IF Not Interested: Update Sheets, remove from sequence
```

### Workflow E: Carousel Auto-Generation
```
Schedule (weekly) → Ollama generates 5 carousel topics
→ For each: generate slide content → Puppeteer renders HTML templates to PNG
→ Merge to PDF → Upload to Postiz → Schedule across the week
```

### Key n8n Workflow Templates (Ready to Import)
- Business lead gen with Apify: https://n8n.io/workflows/5555
- LinkedIn post auto-generation: https://n8n.io/workflows/4374
- Smart email outreach sequence: https://n8n.io/workflows/2833
- B2B sales pipeline (Apollo + Mailgun + AI): https://n8n.io/workflows/7410
- Instagram carousel posts: https://n8n.io/workflows/5833
- LinkedIn carousel with Gemini: https://n8n.io/workflows/7733
- AI multi-platform content factory: https://n8n.io/workflows/3066
- Ollama self-hosted + LLM router: https://n8n.io/workflows/3139
- Full 601+ lead gen templates: https://n8n.io/workflows/categories/lead-generation/

---

## 18. EMAIL DELIVERABILITY SETUP

### SPF Record
```
v=spf1 ip4:YOUR.SERVER.IP include:_spf.google.com ~all
```
- One SPF record per domain
- Max 10 DNS lookups
- Use `~all` during testing, `-all` once confirmed

### DKIM Record
```
selector._domainkey.yourdomain.com  TXT  "v=DKIM1; k=rsa; p=YOUR_PUBLIC_KEY"
```
- 2048-bit keys standard in 2025
- Postal auto-generates DKIM signing

### DMARC Record
```
# Phase 1 (monitoring): p=none
# Phase 2 (after 2-4 weeks): p=quarantine
# Phase 3 (full enforcement): p=reject
v=DMARC1; p=none; rua=mailto:dmarc-reports@yourdomain.com; pct=100
```

### Email Warmup Protocol
- **Week 1-2:** 10-15 emails/day to people who will reply (friends, colleagues)
- **Week 3-4:** 20-30 emails/day, mix in cold contacts
- **Week 5-6:** 30-50 emails/day, start actual campaigns, monitor bounce rates (<2%)
- **Week 7+:** 40-50 emails/inbox/day safe ceiling, never >100

### Verification Tools
- mail-tester.com (free, aim for 9/10)
- MXToolbox.com (validate DNS records)

---

## 19. LINKEDIN SAFETY RULES

| Rule | Details |
|------|---------|
| Account type | Use secondary/burner account. Premium gets warnings; free gets instant bans. |
| Daily limits | Max 20-30 connection requests/day |
| Weekly limits | Max 100-150 connections/week |
| Delays | Randomize by 20-30% (e.g., 42-78s instead of fixed 60s) |
| Activity mix | Don't just send requests. Like, comment, view profiles too. |
| Warm-up period | Run at 10% capacity for first 2 weeks |
| Pending invites | Withdraw unaccepted invites regularly |
| IP address | Dedicated IP (home IP fine for single account) |
| Action quality | If 80%+ of requests are ignored/reported, you're flagged immediately |
| Detection | LinkedIn uses ML behavioral biometrics in 2025-2026 — timing patterns, device consistency, action rhythm |

---

## 20. HARDWARE REQUIREMENTS

### For the Core Stack (n8n + OpenOutreach + Ollama 8B + Postiz)
| Component | Minimum | Recommended |
|-----------|---------|-------------|
| RAM | 16GB | 24GB |
| CPU | 4-core (i5/M1) | 6-core (i7/M2) |
| Storage | 128GB SSD | 256GB SSD |

### For the Full Stack (everything + larger models + image gen)
| Component | Minimum | Recommended |
|-----------|---------|-------------|
| RAM | 24GB | 32-64GB |
| CPU | 6-core | 8+ core |
| Storage | 256GB SSD | 512GB NVMe |
| GPU | Optional | RTX 4060+ for image gen |

### Per-Service Memory Usage
| Service | Idle | Active |
|---------|------|--------|
| n8n | 300-500MB | 1-2GB |
| PostgreSQL (each) | 256MB | 1GB |
| Redis | 64-256MB | 256MB |
| Ollama (8B model) | ~5GB | ~6GB |
| Ollama (27-32B model) | ~16GB | ~20GB |
| OpenOutreach | 500MB-1GB | 1-2GB |
| Postiz | 500MB | 1GB |
| Open WebUI | 256-512MB | 512MB |
| Elasticsearch | 256MB | 512MB |
| Temporal | 256MB | 512MB |

### Laptop Config for 24/7 Operation
- Keep plugged in always
- Disable sleep mode
- Disable display timeout (or set to 5min)
- Set Docker memory limits per container (already configured in docker-compose.yml)
- Apple Silicon (M1/M2/M3/M4) is ideal — great performance-per-watt, runs cool

---

## 21. COST COMPARISON

### SaaS vs Self-Hosted (Monthly)
| Tool Category | SaaS Cost | Self-Hosted Cost |
|---------------|-----------|-----------------|
| LinkedIn automation (Dux-Soup, Expandi) | $99-299 | $0 |
| Email tool (Mailchimp, ActiveCampaign) | $50-300 | $0 |
| CRM (HubSpot, Salesforce) | $50-150/seat | $0 |
| Social scheduler (Buffer, Hootsuite) | $30-100 | $0 |
| Lead enrichment (Clay, Apollo) | $100-500 | $0 (just LLM API) |
| Chatbot (Intercom, Drift) | $74-200 | $0 |
| Content AI (Jasper, Copy.ai) | $49-125 | $0 (Ollama local) |
| Workflow automation (Zapier, Make) | $69-199 | $0 |
| **Total** | **$521-1,873/mo** | **$0-20/mo** |

### What the $0-20 Covers
- $0 if using only Ollama (local AI) + free API keys
- $5-20/month if using cloud APIs (OpenAI/Claude) for higher quality output
- Electricity for running the laptop 24/7 (~$3-8/month)

### If Adding Cold Email Infrastructure (Separate VPS)
- Mautic + Postal VPS: $20-40/month
- 3-5 outreach domains: $10-15/year each
- Total with email: ~$50-80/month

---

## 22. SETUP INSTRUCTIONS

### Prerequisites
- Docker Desktop installed on the spare laptop
- Git installed
- An LLM API key (OpenAI, Anthropic, or free alternatives)

### Quick Start
```bash
# 1. Clone the repo
git clone https://github.com/98soumithr/agency-automation-stack.git
cd agency-automation-stack

# 2. Configure environment
cp .env.example .env
nano .env  # Fill in your API keys and secrets

# 3. Start everything (staged boot order)
./start.sh

# 4. Pull a local AI model
docker exec ollama ollama pull llama3.1:8b

# 5. Access the services
# n8n:          http://localhost:5678
# Open WebUI:   http://localhost:3000
# Postiz:       http://localhost:4007
# OpenOutreach: http://localhost:6080/vnc.html
# OpenOutreach Admin: http://localhost:8000/admin/
```

### First-Time Setup for Each Service

**n8n (localhost:5678):**
1. Create your admin account on first visit
2. Go to Credentials → add OpenAI, Google Sheets, Gmail credentials
3. Import workflow templates from n8n.io/workflows
4. Set up your first automation

**Open WebUI (localhost:3000):**
1. Create account on first visit
2. Select `llama3.1:8b` as your model
3. Create system prompt presets (LinkedIn writer, email writer, lead scorer)
4. Upload client docs for RAG if needed

**Postiz (localhost:4007):**
1. Create account on first visit
2. Go to Settings → connect your social media accounts (need API keys in .env)
3. Create your content calendar
4. Schedule your first posts

**OpenOutreach (localhost:6080/vnc.html):**
1. Open the VNC viewer in your browser
2. The onboarding wizard will ask for: LinkedIn email/password, LLM API key, product description, campaign objective
3. Optionally add seed profile URLs (ideal customer LinkedIn profiles)
4. Accept the legal notice
5. The daemon starts automatically

### Stopping & Restarting
```bash
./stop.sh     # Stop all services (data preserved)
./start.sh    # Start again
```

---

## 23. DAILY AUTOMATION FLOW

When fully configured, here's what happens every day without you touching anything:

```
6:00 AM  — n8n triggers Ollama to generate today's LinkedIn post + carousel script
7:00 AM  — Puppeteer renders carousel slides from HTML templates → PDF
9:00 AM  — Postiz publishes LinkedIn post at optimal engagement time
10:00 AM — OpenOutreach begins daily outreach cycle:
           → Searches for new profiles matching your ICP
           → ML model qualifies them (explore/exploit)
           → Sends ~20 personalized connection requests
           → Follows up with yesterday's new connections via AI DM agent
12:00 PM — Postiz publishes Instagram carousel
2:00 PM  — n8n checks for new LinkedIn connections:
           → Adds to Google Sheet / CRM
           → Triggers cold email sequence if email found
           → Slack notification: "8 new connections today, 3 replied"
5:00 PM  — Postiz publishes X/Twitter thread
8:00 PM  — OpenOutreach pauses (active hours end)
           → Daily stats logged

You check dashboards in the morning → respond to warm replies → close deals
```

---

## 24. EXPANSION ROADMAP

### Phase 1: This Weekend (Core Stack)
- [x] Docker Compose with n8n + Ollama + OpenOutreach + Postiz
- [ ] Configure .env with API keys
- [ ] Run `./start.sh`
- [ ] Pull Ollama model
- [ ] Set up OpenOutreach onboarding
- [ ] Connect one social account in Postiz

### Phase 2: Next Week (Content Automation)
- [ ] Create Open WebUI presets (LinkedIn writer, email writer, lead scorer)
- [ ] Import 3-5 n8n workflow templates
- [ ] Set up Google Sheets as content calendar
- [ ] Build first n8n workflow: AI content → Postiz scheduling

### Phase 3: Week 3 (Email Outreach)
- [ ] Buy 3 outreach domains
- [ ] Set up SPF/DKIM/DMARC
- [ ] Deploy Mautic + Postal on separate VPS
- [ ] Start email warmup (4 weeks before sending)
- [ ] Build n8n workflow: OpenOutreach leads → email enrichment → Mautic sequence

### Phase 4: Month 2 (Full Pipeline)
- [ ] Add Twenty CRM or EspoCRM
- [ ] Add Typebot or Chatwoot for website lead capture
- [ ] Build n8n reply classifier workflow
- [ ] Add Flowise AI chatbot for website
- [ ] Connect everything: LinkedIn leads → email → CRM → follow-up

### Phase 5: Month 3+ (Scale)
- [ ] Add more LinkedIn accounts (if needed)
- [ ] Add ComfyUI for AI image generation (if laptop has GPU)
- [ ] Build custom n8n workflows for specific client niches
- [ ] Add Browser-Use or Skyvern for complex web automations
- [ ] Consider Activepieces alongside n8n for simpler team automations

---

## GITHUB REPOS — QUICK REFERENCE

### Core Stack
| Repo | Stars | Link |
|------|-------|------|
| n8n | 100k+ | https://github.com/n8n-io/n8n |
| Ollama | 130k+ | https://github.com/ollama/ollama |
| Open WebUI | 80k+ | https://github.com/open-webui/open-webui |
| OpenOutreach | — | https://github.com/eracle/OpenOutreach |
| Postiz | — | https://github.com/gitroomhq/postiz-app |

### Your Repos
| Repo | Link |
|------|------|
| OpenOutreach (forked) | https://github.com/98soumithr/OpenOutreach |
| Agency Automation Stack | https://github.com/98soumithr/agency-automation-stack |

### Extended Ecosystem (Add Later)
| Category | Top Pick | Link |
|----------|----------|------|
| CRM | Twenty CRM | https://github.com/twentyhq/twenty |
| Cold Email | Mautic | https://github.com/mautic/mautic |
| SMTP Server | Postal | https://github.com/postalserver/postal |
| Email Sender | listmonk | https://github.com/knadh/listmonk |
| Lead Enrichment | Fire Enrich | https://github.com/firecrawl/fire-enrich |
| Web Scraping | Firecrawl | https://github.com/mendableai/firecrawl |
| Lead Chatbot | Typebot | https://github.com/baptisteArno/typebot.io |
| Live Chat | Chatwoot | https://github.com/chatwoot/chatwoot |
| AI Chatbot Builder | Flowise | https://github.com/FlowiseAI/Flowise |
| Browser Agent | Browser-Use | https://github.com/browser-use/browser-use |
| Anti-Detect Browser | Camoufox | https://github.com/daijro/camoufox |
| AI Sales Agent | SalesGPT | https://github.com/filip-michalsky/SalesGPT |
| Image Generation | ComfyUI | https://github.com/comfyanonymous/ComfyUI |
| LinkedIn API | linkedin-api | https://github.com/tomquirk/linkedin-api |
| Instagram API | instagrapi | https://github.com/subzeroid/instagrapi |
| Email Verification | Reacher | https://github.com/reacherhq/check-if-email-exists |
| OSINT Email Finder | theHarvester | https://github.com/laramies/theHarvester |

---

*This document was compiled from 7 parallel research agents covering: LinkedIn automation, content creation, sales infrastructure, browser automation, n8n workflows, local AI models, and email/CRM tools. Last updated: March 2026.*
