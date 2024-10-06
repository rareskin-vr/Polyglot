from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from googletrans import Translator, LANGUAGES # Import the googletrans library

def index(request):
    return render(request, 'translation/index.html')

def translate_text(source_lang, target_lang, text):
    translator = Translator()  # Create a Translator instance
    try:
        # Check if the source and target languages are valid
        if source_lang not in LANGUAGES or target_lang not in LANGUAGES:
            return f"Invalid language code: {source_lang} or {target_lang}"

        # Use the translator to perform the translation
        translation = translator.translate(text, src=source_lang, dest=target_lang)
        print(f"Translation object: {translation}") 


        # Log the translation object
        # Return the translated text
        return translation if translation else "No translation found"

    except Exception as e:
        # Log any errors
        print(f"Error occurred: {e}")
        return "Translation failed"

@csrf_exempt  # Allow CSRF exemption for the translate view
def translate(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        source_lang = data.get('source_lang')
        target_lang = data.get('target_lang')
        text = data.get('text')

        # Perform translation
        translation_result = translate_text(source_lang, target_lang, text)
        print(f"Translation result for {target_lang}: {translation_result}")
        # Return translation, romanized result, and pronunciation
        return JsonResponse({
            "translation": translation_result.text,
            "pronunciation": translation_result.pronunciation
        }, safe=False)

    return JsonResponse({"error": "Invalid request"}, status=400)
