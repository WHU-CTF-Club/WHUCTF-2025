namespace EagleWeb {
  interface Image {
    id: string;
    name: string;
    size: number;
    timeStamp: number;
    desc: string;
    width: number;
    height: number;
  }

  interface Env {
    host: string;
    limit: number;
    images_protocol: string;
    images_hostname: string;
    images_port: string;
  }
}
