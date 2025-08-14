export interface AxiosResponse<T> {
    data: T;
    status: number;
    statusText: string;
    headers: Record<string, string>;
    config: AxiosRequestConfig;
    request?: any;
}

export interface AxiosRequestConfig {
    url?: string;
    method?: string;
    data?: any;
    headers?: Record<string, string>;
    params?: Record<string, string>;
    timeout?: number;
}
