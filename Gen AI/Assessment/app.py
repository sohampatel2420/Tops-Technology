import streamlit as st
from transformers import pipeline
import torch

st.set_page_config(page_title="Multi-Task NLP Assistant", layout="wide")
st.title(" Multi-Task NLP Assistant")
st.markdown(
    "Use the sidebar to choose a task, paste text (or a paragraph), and press **Run**. "
    "Models are loaded on demand and cached for faster repeated use."
)

# Sidebar
with st.sidebar:
    st.header("Task selection")
    task = st.radio("Choose an NLP task:",
                    ("Text Summarization", "Question Answering", "Named Entity Recognition", "Translation (EN → HI/FR/ES/DE)"))

    st.markdown("---")
    st.markdown("**Model (pre-selected):**")
    if task == "Text Summarization":
        st.write("facebook/bart-large-cnn")
    elif task == "Question Answering":
        st.write("deepset/roberta-large-squad2")
    elif task == "Named Entity Recognition":
        st.write("dslim/bert-base-NER")
    else:
        st.write("Helsinki-NLP/opus-mt-en-fr | opus-mt-en-es | opus-mt-en-de")

    st.markdown("---")
    run = st.button("Run")

# Input area in main UI
st.subheader("Input text / context")
text_input = st.text_area("Paste your paragraph, passage or question here", height=100)

# Extra inputs for specific tasks
question = None
target_lang = None
if task == "Question Answering":
    st.markdown("**Question (for QA)**")
    question = st.text_input("Type a question that can be answered from the text above")

if task.startswith("Translation"):
    target_lang = st.selectbox("Translate English →", ("Hindi (hi)","French (fr)", "Spanish (es)", "German (de)"))

# Helper: device selection
device = 0 if torch.cuda.is_available() else -1

# Caching model loaders to avoid reloading on each run
@st.cache_resource
def get_summarizer():
    return pipeline("summarization", model="facebook/bart-large-cnn", device=device)

@st.cache_resource
def get_qa():
    return pipeline("question-answering", model="deepset/roberta-large-squad2", device=device)

@st.cache_resource
def get_ner():
    return pipeline("ner", model="dslim/bert-base-NER", aggregation_strategy="simple", device=device)

@st.cache_resource
def get_translator(lang_code):
    model_map = {
        "hi": "Helsinki-NLP/opus-mt-en-hi",
        "fr": "Helsinki-NLP/opus-mt-en-fr",
        "es": "Helsinki-NLP/opus-mt-en-es",
        "de": "Helsinki-NLP/opus-mt-en-de",
    }
    model = model_map[lang_code]
    return pipeline("translation", model=model, device=device)


# Core run logic
if run:
    # Basic validation
    if not text_input or text_input.strip() == "":
        st.error(" Please provide some input text before running the task.")
    else:
        try:
            if task == "Text Summarization":
                with st.spinner("Running summarization..."):
                    summarizer = get_summarizer()
                    # Hugging Face summarizers often have max_length params; adjust for long text
                    summary = summarizer(text_input, max_length=130, min_length=30, do_sample=False)
                    st.markdown("###  Summary")
                    st.write(summary[0]['summary_text'])

            elif task == "Question Answering":
                if not question or question.strip() == "":
                    st.error(" For QA, please type a question in the 'Question' box.")
                else:
                    with st.spinner("Running question answering..."):
                        qa = get_qa()
                        result = qa(question=question, context=text_input)
                        st.markdown("###  Question")
                        st.write(question)
                        st.markdown("###  Answer")
                        st.write(result.get('answer'))

            elif task == "Named Entity Recognition":
                with st.spinner("Running NER..."):
                    ner = get_ner()
                    entities = ner(text_input)
                    st.markdown("###  Named Entities")
                    if not entities:
                        st.write("No entities found.")
                    else:
                        # Present as a Markdown table
                        rows = ["| Entity | Label | Score |", "|---|---:|---:|"]
                        for e in entities:
                            ent = e.get('word') or e.get('entity_group')
                            label = e.get('entity_group') or e.get('entity')
                            score = e.get('score')
                            rows.append(f"| {ent} | {label} | {score:.3f} |")
                        st.markdown("\n".join(rows))

            elif task.startswith("Translation"):
                # Map selection to code
                code = (
                            "hi" if target_lang.startswith("Hindi") else
                            "fr" if target_lang.startswith("French") else
                            "es" if target_lang.startswith("Spanish") else
                            "de"
                        )

                with st.spinner(f"Translating to {code}..."):
                    translator = get_translator(code)
                    translated = translator(text_input)
                    # translator returns list of dicts
                    translated_text = translated[0].get('translation_text')
                    st.markdown(f"###  Translation (EN → {code.upper()})")
                    st.write(translated_text)

        except Exception as e:
            st.error(f"An error occurred while running the model: {e}")
            st.exception(e)

# Footer / tips
st.markdown("---")
st.caption("Tip: For long inputs you may want to shorten or split the text (summarizers and some translation models have token limits). If you have a GPU available, the app will use it automatically.")



# example text for NER test : "On December 12, 2024, Sam Altman, the CEO of OpenAI, met with government officials in Tokyo to discuss the future of artificial intelligence regulations. During the summit, Microsoft announced a $5 billion investment to build a new data center in Hokkaido, which is scheduled to be operational by mid-2026. Meanwhile, Elon Musk criticized the move on X, suggesting that Tesla would focus its robotics efforts in Texas and Berlin instead."
# example text for translation test : "Delhi is the capital of India. It is a very old and historical city. There are many famous buildings here, such as the Red Fort and India Gate. Millions of tourists come to see these places every year. Delhi's weather is very hot in the summer and very cold in the winter. People here speak various languages, but Hindi is the main language."
