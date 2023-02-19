<details>
<summary>
<strong> Read this Guide in English </strong>
</summary>
    <ul>
        <li><a href="./README.md"> English </a></li>
    </ul>

</details>

# Chatify App - Aplicação de troca de mensagens em tempo real

Esta é uma aplicação de bate-papo/ conversa em tempo real construída com Flutter e Firebase. O aplicativo permite que os usuários criem contas, encontrem e adicionem amigos, e enviem e recebam mensagens em tempo real com uma experiência de usuário enriquecida.

Ele usa o Firebase Cloud Firestore, bem como o pacote Firebase Authentication e Firebase Storage, que equipa este aplicativo com um banco de dados NoSQL baseado em nuvem e métodos de autenticação seguros.

## **Funcionalidades:**

**Autenticação**: os usuários podem criar contas, fazer login e logout usando seu e-mail e senha.
**Mensagens em Tempo Real**: os usuários podem enviar e receber mensagens em tempo real.
**Pesquisar e Adicionar Amigos**: os usuários podem procurar outros usuários pelo endereço de e-mail e adicioná-los como amigos.
**Perfil do Usuário**: os usuários podem visualizar seu próprio perfil, editar sua foto de perfil e visualizar sua lista de amigos.

## Demonstração

![Chatify-app-preview](/.github/images/preview/Chatify-app-preview.png)

### Dependências

1. [Firebase_Core](https://pub.dev/packages/firebase_core)

1. [Firebase_Storage](https://pub.dev/packages/firebase_storage)

1. [Firebase_Analytics](https://pub.dev/packages/firebase_analytics)

1. [Firebase_Auth](https://pub.dev/packages/firebase_auth)

1. [Cloud_Firestore](https://pub.dev/packages/cloud_firestore)

1. [Fornecedor](https://pub.dev/packages/provider)

1. [Get_It](https://pub.dev/packages/get_it)

1. [File_Picker](https://pub.dev/packages/file_picker)

1. [Flutter_Spinkit](https://pub.dev/packages/flutter_spinkit)

1. [Flutter_Keyboard_Visibility](https://pub.dev/packages/flutter_keyboard_visibility)

1. [Timeago](https://pub.dev/packages/timeago)

## Instalação

##### 1. Clone o repositório

```bash
git clone https://github.com/edilsonmatola/ChatifyApp-flutter.git
```

##### 2. Mova para a pasta desejada

```bash
cd ChatifyApp-flutter
```

3. Crie projecto do Firebase
4. Active a autenticação
5. Crie regras do Firestore
6. Crie aplicativos para Android, iOS e Web

##### 7. Para executar o aplicativo, basta escrever os seguintes comandos:

```bash
flutter pub get
# flutter emulators --launch "emulator_id" (para obter o Android Simulator)
open -a simulator (para obter o iOS Simulator)
flutter run
flutter run -d chrome --web-renderer html (para ver a melhor saída)
```

## **Contribuindo**

Contribuições para o aplicativo são bem-vindas! Se você deseja contribuir, por favor, reserve um momento para revisar o arquivo [CONTRIBUIÇÃO](./CONTRIBUTING.md). Este arquivo descreve as diretrizes e processos para contribuir para o Habitual.

Se tiver alguma dúvida ou preocupação sobre o processo de contribuição, não hesite em entrar em contacto comigo [aqui](https://github.com/edilsonmatola/ChatifyApp-flutter/issues). Eu sempre estou feliz em ajudar novos colaboradores a se actualizarem.

# **Licença**

Este projeto está licenciado sob a **Licença MIT**. Sinta-se à vontade para usá-lo como ponto de partida para seus próprios projectos!
