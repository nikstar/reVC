#pragma once

struct GLFWwindow;

void MacSetFullScreen(GLFWwindow *window, bool fullScreen);
// Pass a null window to stop observing before GLFW destroys it.
void MacObserveFullScreen(GLFWwindow *window, void (*changed)(bool));
