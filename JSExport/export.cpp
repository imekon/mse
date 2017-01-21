#include <windows.h>
#include <duktape.h>

#define EXPORT __cdecl

extern "C"
{
	extern bool EXPORT JSExport(const wchar_t *scriptFilename, const wchar_t *output, const wchar_t *text)
	{
		char scriptFilenameBuffer[MAX_PATH];
		char outputBuffer[MAX_PATH];
		auto length = wcslen(text);
		auto textBuffer = new char[length + 1];

		WideCharToMultiByte(CP_ACP, 0, scriptFilename, -1, scriptFilenameBuffer, MAX_PATH, nullptr, nullptr);
		WideCharToMultiByte(CP_ACP, 0, output, -1, outputBuffer, MAX_PATH, nullptr, nullptr);
		WideCharToMultiByte(CP_ACP, 0, text, -1, textBuffer, static_cast<int>(length), nullptr, nullptr);

		auto context = duk_create_heap_default();

		if (duk_peval_file(context, scriptFilenameBuffer) != 0)
		{
			return false;
		}

		duk_pop(context);

		duk_push_string(context, textBuffer);
		duk_push_string(context, outputBuffer);
		duk_push_string(context, "export");
		if (duk_pcall(context, 3) != 0)
		{
			return false;
		}

		duk_destroy_heap(context);
		delete [] textBuffer;

		return true;
	}
}
