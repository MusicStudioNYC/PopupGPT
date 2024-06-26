# PopupGPT
Instant ChatGPT mini popup via hotkey, for Windows (AHK)

<img src="https://github.com/MusicStudioNYC/PopupGPT/assets/53878072/741d3854-c392-4557-9b62-07b6c0bbae55" width="350">


## Setup
1. Download and run the EXE file (or alternatively, the "AHK" file from the "src" directory, if you have [AutoHotKey](https://www.autohotkey.com/) v1 installed).
2. Paste your OpenAI API key (only needs to be done once, then it's stored locally on your computer in the system registry).

If you don't know how to find your API key, see here:


[![How to generate an API key](http://img.youtube.com/vi/nafDyRsVnXU/0.jpg)](http://www.youtube.com/watch?v=nafDyRsVnXU)

3. Add the EXE file (or a shortcut to it) inside your system startup folder if you want it to automatically start with your computer without needing to run the file after every system restart.
To find your system startup folder, open Run (WIN+R) and paste this: `shell:startup`

The file only needs to run once (either by manually running it, or adding it to your startup folder). (Closing the app only minimizes it to the system tray.)
Once the app is running, here's how to enjoy it:

## Usage
1. Use hotkey **ALT+`** (backtick is found to the left of "1") to show the dialog (and reset its contents).
2. Once the dialog is visible, type your prompt (e.g. "I'm too _ to come to tonight's meeting (5 options)").
3. Execute the call to GPT.
  a. For GPT 3.5 (faster and cheaper) press **CTRL+Enter** (or press the on-screen button).
  b. For GPT 4 (smarter, slower) press **SHIFT+ENTER** (or press the on-screen button).
4. To copy the entire output press **ALT+C** (or press the on-screen button). To copy just a portion of the response, make a selection and use CTRL+C, as usual.

## Privacy
Your prompts and API keys do not pass through our servers or anything like that. You API key is stored locally on your computer in the system registry, then all calls to GPT are made directly to the OpenAI API endpoint (https://api.openai.com/v1/chat/completions)

## Cost
OpenAI gives you free $5 credit to use with your API. Those $5 should be enough to last you nearly forever if you only use this app for short Q&A's. For longer Q&A's, like essay generation, it is recommended to use the regular chat.openai.com for several benefits. The purpose of this app is meant for quick and concise on-the-fly answers.

The cost for the GPT 3.5 (turbo-0125) and even the more expensive GPT-4 (0125-preview) are both so minimal that you don't really have to worry about the cost. Instead, choose GPT-3.5 for faster response, but use GPT-4 if you require a better answer from this more advanced model (but honestly, it's happened before that 3.5 gave a better answer than 4!)

Example:

**Prompt:** `js get current date in this format: mm/dd/yyyy`

**Reponse:**
```javascript
const currentDate = new Date().toLocaleDateString('en-US', { month: '2-digit', day: '2-digit', year: 'numeric' });
console.log(currentDate);
```

The total cost of the above Q&A is:

**GPT-3.5:** $0.0000715 (with **1 cent**, you can run such a Q&A **140 times**. With your $5 credit, you can ask such a Q&A **69,930 times**.) 

**GPT-4:** $0.00143 (with **1 cent**, you can run such a Q&A **7 times**. With your $5 credit, you can ask such a Q&A **3,496** times.) 
In short, you don't have to worry about cost.

## Memory (or the lack thereof)
Note that this isn't a chat, there's no memory of what you typed before. Every question you ask is like the first time you met. If you need a chat conversation experience, use the regular chat.openai.com.

## Build
If you want to build an EXE from the AHK source code, you can use teh Ahk2Exe.exe include GUI tool.
