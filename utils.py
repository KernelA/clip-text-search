from typing import Iterable, List

import torch
from torchvision import io
from torchvision import transforms
from torchvision.io.image import ImageReadMode
import clip
import faiss
import numpy as np
from PIL import Image
from tqdm import tqdm

@torch.no_grad()
def build_index(model, transformation, device, image_path: List[str], image_batch: int = 32):
    index = None

    for i in tqdm(range(0, len(image_path), image_batch), desc="Encode images"):
        end = min(len(image_path), i + image_batch)
        batch_images_path = image_path[i:end]
        img_batch = load_image_batch(batch_images_path, transformation).to(device)
        img_embeddings = model.encode_image(img_batch)

        img_embeddings /= img_embeddings.norm(dim=-1, keepdim=True)
        img_embeddings = img_embeddings.cpu().numpy()
        
        if index is None:
            index = faiss.IndexFlatIP(img_embeddings.shape[1])
        
        index.add(img_embeddings.astype(np.float32))
    
    return index


def load_image_batch(image_paths: Iterable[str], transform):
    images = []
    for image_path in image_paths:
        tensor_image = transform(Image.open(image_path)).unsqueeze(0)
        images.append(tensor_image)

    return torch.cat(images, dim=0)


def get_model(model_name: str, device):
    model, preprocess = clip.load(model_name, device=device, jit=True)
    return model, preprocess


def load_image(path_to_image: str, size: int = 600):
    image = io.read_image(path_to_image, ImageReadMode.RGB)
    return transforms.Resize(size)(image).permute(1, 2, 0)


@torch.no_grad()
def get_text_emb(model, text: str, device):
    text_tokens = clip.tokenize(text).to(device)
    text_features = model.encode_text(text_tokens)
    text_features /= text_features.norm(dim=-1, keepdim=True)
    return text_features.cpu().numpy()
