#!/bin/bash
if [ -n "$PS1" ] && [ -z "$DURGA_WELCOME_SHOWN" ]; then
    export DURGA_WELCOME_SHOWN=1
    echo -e "\e[1;36m"
    echo "  ======================================================="
    echo "    WELCOME TO DURGA OS - Ultra-Fast, Secure & Seamless  "
    echo "  ======================================================="
    echo -e "\e[0m"
    echo -e "  \e[32m✔ Native Linux Apps\e[0m (apt, flatpak, snap)"
    echo -e "  \e[32m✔ Windows Apps\e[0m (Wine / Bottles pre-configured)"
    echo -e "  \e[32m✔ Android Apps\e[0m (Waydroid integration ready)"
    echo -e "  \e[32m✔ Security\e[0m (AppArmor enforcing, UFW enabled)"
    echo -e "  Type \e[1;33mdurga-app-center\e[0m to launch the App Center."
    echo ""
fi
