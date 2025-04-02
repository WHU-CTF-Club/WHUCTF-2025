def merge(src, dst):
    for k, v in src.items():
        if hasattr(dst, '__getitem__'):
            if type(v) is dict:
                merge(v, dst.get(k))
            elif type(v) is list and type(dst.get(k)) == list:
                for n, i, j in enumerate(zip(dst.get(k), v)):
                    if type(j) is dict:
                        merge(j, i)
                    else:
                        dst.get(k)[n] = v[n]
            else:
                dst[k] = v
        elif hasattr(dst, k):
            if type(v) is dict:
                merge(v, getattr(dst, k))
            elif type(v) is list and type(getattr(dst, k)) == list:
                for n, var in enumerate(zip(getattr(dst, k), v)):
                    i, j = var[0], var[1]
                    if type(j) is dict:
                        merge(j, i)
                    else:
                        getattr(dst, k)[n] = v[n]
            else:
                setattr(dst, k, v)
        else:
            setattr(dst, k, v)
