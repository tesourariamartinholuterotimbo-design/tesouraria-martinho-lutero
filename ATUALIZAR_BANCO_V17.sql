-- Tesouraria Martinho Lutero — atualização do banco para V17.0
-- Execute uma única vez no Supabase SQL Editor (Editor SQL).

ALTER TABLE public.ofertas
ADD COLUMN IF NOT EXISTS ofertante_nome TEXT;

-- Preserva os nomes das ofertas que já existem.
UPDATE public.ofertas o
SET ofertante_nome = p.nome
FROM public.ofertantes p
WHERE o.ofertante_id = p.id
  AND o.ofertante_nome IS NULL;

-- Permite excluir o cadastro do ofertante sem apagar a oferta histórica.
ALTER TABLE public.ofertas
DROP CONSTRAINT IF EXISTS envelope_exige_ofertante;

ALTER TABLE public.ofertas
DROP CONSTRAINT IF EXISTS ofertas_ofertante_id_fkey;

ALTER TABLE public.ofertas
ADD CONSTRAINT ofertas_ofertante_id_fkey
FOREIGN KEY (ofertante_id)
REFERENCES public.ofertantes(id)
ON DELETE SET NULL;
